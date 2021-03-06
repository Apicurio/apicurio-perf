#!/bin/sh

echo "------------------------------------------------------"
echo " Creating OSD cluster to deploy performance test."
echo "   Many steps to follow.  Please play along at home..."
echo "------------------------------------------------------"
echo ""
echo ""

OCM_API=https://api.stage.openshift.com

OCM_TOKEN=
AWS_ACCOUNT_ID=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
CLUSTER_NAME=$1
CLUSTER_REGION=$2

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
sleep 5

# Wait for cluster to be created
#########################################
echo "Cluster created, waiting for provisioning to start."
CLUSTER_ID=
while [ "x$CLUSTER_ID" = "x" ]
do
  CLUSTER_ID=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -c -r "(.items[] | select(.name | contains(\"$CLUSTER_NAME\"))).id"`
  [[ $CLUSTER_ID =~ ^null$ ]] && CLUSTER_ID=""
  sleep 5
done
echo "----------"
echo "New cluster with ID [$CLUSTER_ID] is being provisioned."
echo "(Will now wait for cluster to be fully provisioned)"
echo "----------"

CLUSTER_URL=
while [ "x$CLUSTER_URL" = "x" ]
do
  CLUSTER_STATUS=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.id | contains(\"$CLUSTER_ID\"))).status.state"`
  echo "  Provisioning Status: $CLUSTER_STATUS"

  CLUSTER_URL=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.id | contains(\"$CLUSTER_ID\"))).api.url"`
  [[ $CLUSTER_URL =~ ^null$ ]] && CLUSTER_URL=""
  sleep 30
done
echo "----------"
echo "Cluster successfully provisioned!"
echo "Cluster URL: $CLUSTER_URL"
CLUSTER_CONSOLE=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.id | contains(\"$CLUSTER_ID\"))).console.url"`
echo "Cluster Console URL: $CLUSTER_CONSOLE"
echo "----------"

echo ""
echo "====================================================="
echo "export CLUSTER_ID=$CLUSTER_ID"
echo "export CLUSTER_CONSOLE=$CLUSTER_CONSOLE"
echo "export CLUSTER_URL=$CLUSTER_URL"
echo "====================================================="
