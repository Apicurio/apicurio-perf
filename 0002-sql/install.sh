#!/bin/sh

echo "------------------------------------------------------"
echo " Creating OSD cluster to deploy apicurio-registry-mem."
echo "   Many steps to follow.  Please play along at home..."
echo "------------------------------------------------------"
echo ""
echo ""

OCM_API=https://api.stage.openshift.com

# Usage: install.sh <cluster-name> <cluster-region> <rds-user> <rds-password>

OCM_TOKEN=
AWS_ACCOUNT_ID=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
CLUSTER_NAME=$1
CLUSTER_REGION=$2
RDS_USER=$3
RDS_PASS=$4

RDS_INSTANCE=regdb
RDS_DB=registry

# Check required tools
#########################################
echo "Checking for required tools..."
echo "   `jq --version`"
echo "   `ocm version`"
echo "   `oc version --client`"
echo "   `aws --version`"
echo "Looks good!"
echo ""

# Load secrets
#########################################
if [ -f ~/.mas/settings.env ]
then
  source ~/.mas/settings.env
else
  echo "Missing file: ~/.mas/settings.env.  Please create this file and add the required ENV variables.  Examples:"
  echo "---"
  echo "OCM_TOKEN="
  echo "AWS_ACCOUNT_ID="
  echo "AWS_ACCESS_KEY="
  echo "AWS_SECRET_KEY="
  echo "---"
  echo ""
  exit 1
fi

# Prompt for cluster name and region
#########################################
while [ "x$CLUSTER_NAME" = "x" ]
do
  read -p "Cluster name: " CLUSTER_NAME
done
while [ "x$CLUSTER_REGION" = "x" ]
do
  read -p "Cluster region (e.g. us-east-1): " CLUSTER_REGION
done
while [ "x$RDS_USER" = "x" ]
do
  read -p "RDS Database Username: " RDS_USER
done
while [ "x$RDS_PASS" = "x" ]
do
  read -p "RDS Database Password: " RDS_PASS
done
while [ "x$REGISTRY_REPLICAS" = "x" ]
do
  read -p "# of App Replicas (e.g. 4): " REGISTRY_REPLICAS
done

# Validate inputs
#########################################
# Todo: validate cluster name :: [[ $CLUSTER_NAME =~ ^[a-zA-Z\-]{4,16}$ ]] && echo "" || (echo "Invalid cluster name.  Must be 4-16 characters with alpha and hyphens." && exit 1)
# Todo: validate the region

# Echo some relevant settings
#########################################
echo "=========================================="
echo "Cluster name: $CLUSTER_NAME"
echo "Cluster region: $CLUSTER_REGION"
echo "=========================================="


# Clean the work directory
#########################################
WORK_DIR=./target
rm -rf $WORK_DIR
mkdir -p ./target

# Login using ocm
#########################################
echo "Logging in using 'ocm login'"
ocm login --url=$OCM_API/ --token=$OCM_TOKEN --insecure

# Prepare the cluster JSON descriptor
#########################################
jq ".name = \"$CLUSTER_NAME\"" cluster.json > $WORK_DIR/_cluster.tmp1.json
jq ".aws.account_id = \"$AWS_ACCOUNT_ID\"" $WORK_DIR/_cluster.tmp1.json > $WORK_DIR/_cluster.tmp2.json
jq ".aws.access_key_id = \"$AWS_ACCESS_KEY\"" $WORK_DIR/_cluster.tmp2.json > $WORK_DIR/_cluster.tmp3.json
jq ".aws.secret_access_key = \"$AWS_SECRET_KEY\"" $WORK_DIR/_cluster.tmp3.json > $WORK_DIR/_cluster.tmp4.json

jq ".region.id = \"$CLUSTER_REGION\"" $WORK_DIR/_cluster.tmp4.json > $WORK_DIR/_cluster.tmp5.json
jq ".region.display_name = \"$CLUSTER_REGION\"" $WORK_DIR/_cluster.tmp5.json > $WORK_DIR/_cluster.tmp6.json
jq ".region.name = \"$CLUSTER_REGION\"" $WORK_DIR/_cluster.tmp6.json > $WORK_DIR/_cluster.tmp7.json

mv $WORK_DIR/_cluster.tmp7.json $WORK_DIR/cluster.json
rm $WORK_DIR/_cluster.tmp*.json

# Create cluster
#########################################
echo "Creating cluster using 'ocm post'"
ocm post "$OCM_API/api/clusters_mgmt/v1/clusters" --body=target/cluster.json
sleep 2

# Wait for cluster to be created
#########################################
echo "Cluster created, waiting for provisioning to start."
CLUSTER_ID=
while [ "x$CLUSTER_ID" = "x" ]
do
  sleep 5
  CLUSTER_ID=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.name | contains(\"$CLUSTER_NAME\"))).id"`
  [[ $CLUSTER_ID =~ ^null$ ]] && CLUSTER_ID=""
done
echo "----------"
echo "New cluster with ID [$CLUSTER_ID] is being provisioned."
echo "(Will now wait for cluster to be fully provisioned)"
echo "----------"

CLUSTER_URL=
while [ "x$CLUSTER_URL" = "x" ]
do
  sleep 45

  CLUSTER_URL=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.id | contains(\"$CLUSTER_ID\"))).api.url"`
  CLUSTER_STATUS=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.id | contains(\"$CLUSTER_ID\"))).status.state"`
  echo "  Provisioning Status: $CLUSTER_STATUS"

  [[ $CLUSTER_URL =~ ^null$ ]] && CLUSTER_URL=""
done
echo "----------"
echo "Cluster successfully provisioned!"
echo "Cluster URL: $CLUSTER_URL"
CLUSTER_CONSOLE=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.id | contains(\"$CLUSTER_ID\"))).console.url"`
echo "Cluster Console URL: $CLUSTER_CONSOLE"
echo "----------"

# Provision RDS instance
#########################################
aws rds create-db-instance --db-name $RDS_DB --db-instance-identifier $RDS_INSTANCE --allocated-storage 20 --db-instance-class db.m5.large --engine postgres --master-username $RDS_USER --master-user-password $RDS_PASS --no-multi-az --engine-version 12.5 --publicly-accessible --storage-type gp2

# Wait for RDS instance to be provisioned
#########################################
RDS_STATUS=
while [ "x$RDS_STATUS" != "xavailable" ]
do
  sleep 10
  RDS_STATUS=`aws rds describe-db-instances | jq -r "(.DBInstances[] | select(.DBInstanceIdentifier | contains(\"$RDS_INSTANCE\"))).DBInstanceStatus"`
  echo "RDS instance status: $RDS_STATUS"
done
RDS_HOST=`aws rds describe-db-instances | jq -r "(.DBInstances[] | select(.DBInstanceIdentifier | contains(\"$RDS_INSTANCE\"))).Endpoint.Address"`
RDS_PORT=`aws rds describe-db-instances | jq -r "(.DBInstances[] | select(.DBInstanceIdentifier | contains(\"$RDS_INSTANCE\"))).Endpoint.Port"`
RDS_JDBC_URL=jdbs:postgresql://$RDS_HOST:$RDS_PORT/registry
echo "----------"
echo "RDS Instance successfully provisioned."
echo "JDBC URL: $RDS_JDBC_URL"
echo "----------"

export CLUSTER_ID
export RDS_INSTANCE
export RDS_DB=registry
export RDS_USER
export RDS_PASS
export RDS_HOST
export RDS_PORT
export PROJECT_NAME=apicurio-registry
export REGISTRY_REPLICAS

echo "================================================="
echo "export CLUSTER_ID=$CLUSTER_ID"
echo "export RDS_INSTANCE=$RDS_INSTANCE"
echo "export RDS_DB=registry=$RDS_DB"
echo "export RDS_USER=$RDS_USER"
echo "export RDS_PASS=$RDS_PASS"
echo "export RDS_HOST=$RDS_HOST"
echo "export RDS_PORT=$RDS_PORT"
echo "export PROJECT_NAME=$PROJECT_NAME"
echo "export REGISTRY_REPLICAS=$REGISTRY_REPLICAS"
echo "================================================="

echo "OCM install complete.  Deploying application."

exec ./deploy.sh
