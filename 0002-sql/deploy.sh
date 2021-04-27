#!/bin/sh

OCM_API=https://api.stage.openshift.com


# ENV variables supported
#CLUSTER_ID
#RDS_INSTANCE
#RDS_DB=registry
#RDS_USER
#RDS_PASS
#RDS_HOST
#RDS_PORT
#PROJECT_NAME

while [ "x$CLUSTER_ID" = "x" ]
do
  read -p "OCM Cluster ID: " CLUSTER_ID
done
while [ "x$RDS_HOST" = "x" ]
do
  read -p "RDS Host: " RDS_HOST
done
while [ "x$RDS_PORT" = "x" ]
do
  read -p "RDS Port: " RDS_PORT
done
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
while [ "x$PROJECT_NAME" = "x" ]
do
  read -p "OCM Project Name: " PROJECT_NAME
done
while [ "x$REGISTRY_REPLICAS" = "x" ]
do
  read -p "# of App Replicas (e.g. 4): " REGISTRY_REPLICAS
done

# Update deployment YAML with RDS info
#########################################
cat registry-deployment.yaml | \
   sed "s/REGISTRY_REPLICAS/$REGISTRY_REPLICAS/g" | \
   sed "s/RDS_HOST/$RDS_HOST/g" | \
   sed "s/RDS_PORT/$RDS_PORT/g" | \
   sed "s/RDS_DB/$RDS_DB/g" | \
   sed "s/RDS_USER/$RDS_USER/g" | \
   sed "s/RDS_PASS/$RDS_PASS/g" > target/registry-deployment.yaml

# Get kube admin credentials
#########################################
echo "Getting kube admin credentials"
CLUSTER_URL=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.id | contains(\"$CLUSTER_ID\"))).api.url"`
CLUSTER_USER=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.user`
CLUSTER_PASSWORD=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.password`

# Login to cluster
#########################################
echo "Logging in to cluster using 'oc login'"
oc login --insecure-skip-tls-verify --username=$CLUSTER_USER --server=$CLUSTER_URL --password=$CLUSTER_PASSWORD

# Install application to cluster
#########################################
echo "Creating project and deploying registry"
oc new-project $PROJECT_NAME
oc apply -f target/registry-deployment.yaml

# Wait for application to be deployed
#########################################
echo "Waiting for application deployment to complete..."
sleep 30
echo "Getting application route/host."
APP_HOST=`oc get route -o json | jq -r .items[0].spec.host`

echo "----------"
echo "Success!"
echo "Application host: $APP_HOST"
echo "Registry Console: http://$APP_HOST/ui"
echo "----------"
