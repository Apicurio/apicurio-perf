#!/bin/sh

OCM_API=https://api.stage.openshift.com

# to fail fast if any commands fail
set -e

AWS_ACCOUNT_ID=
AWS_ACCESS_KEY=
AWS_SECRET_KEY=
RDS_INSTANCE=regdb
RDS_DB=registry

# Check required tools
#########################################
echo "Checking for required tools..."
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

# Prompt for RDS info
#########################################
while [ "x$RDS_INSTANCE" = "x" ]
do
  read -p "RDS Instance: " RDS_INSTANCE
done
while [ "x$RDS_DB" = "x" ]
do
  read -p "RDS Database: " RDS_DB
done
while [ "x$RDS_USER" = "x" ]
do
  read -p "RDS User: " RDS_USER
done
while [ "x$RDS_PASS" = "x" ]
do
  read -p "RDS Password: " RDS_PASS
done

echo "Creating RDS instance"

# Provision RDS instance
#########################################
aws rds create-db-instance \
    --db-name $RDS_DB \
    --db-instance-identifier $RDS_INSTANCE \
    --allocated-storage 100 \
    --db-instance-class db.m5.4xlarge \
    --engine postgres \
    --master-username $RDS_USER \
    --master-user-password $RDS_PASS \
    --no-multi-az \
    --engine-version 12.5 \
    --publicly-accessible \
    --storage-type gp2

# Wait for RDS instance to be provisioned
#########################################
RDS_STATUS=
while [ "x$RDS_STATUS" != "xavailable" ]
do
  sleep 10
  RDS_STATUS=`aws rds describe-db-instances --db-instance-identifier $RDS_INSTANCE | jq -r "(.DBInstances[]).DBInstanceStatus"`
  echo "RDS instance status: $RDS_STATUS"
done
RDS_HOST=`aws rds describe-db-instances --db-instance-identifier $RDS_INSTANCE | jq -r "(.DBInstances[]).Endpoint.Address"`
RDS_PORT=`aws rds describe-db-instances --db-instance-identifier $RDS_INSTANCE | jq -r "(.DBInstances[]).Endpoint.Port"`
RDS_JDBC_URL=jdbs:postgresql://$RDS_HOST:$RDS_PORT/registry
echo "----------"
echo "RDS Instance successfully provisioned."
echo "JDBC URL: $RDS_JDBC_URL"
echo "----------"

export RDS_INSTANCE
export RDS_DB
export RDS_USER
export RDS_PASS
export RDS_HOST
export RDS_PORT

echo "================================================="
echo "export RDS_INSTANCE=$RDS_INSTANCE"
echo "export RDS_DB=$RDS_DB"
echo "export RDS_USER=$RDS_USER"
echo "export RDS_PASS=$RDS_PASS"
echo "export RDS_HOST=$RDS_HOST"
echo "export RDS_PORT=$RDS_PORT"
echo "================================================="
