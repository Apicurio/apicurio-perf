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
  read -p "OCM App Cluster Name: " CLUSTER_NAME
  CLUSTER_ID=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.name | contains(\"$CLUSTER_NAME\"))).id"`
  [[ $CLUSTER_ID =~ ^null$ ]] && CLUSTER_ID=""
done
while [ "x$PROJECT_NAME" = "x" ]
do
  read -p "OCM Project Name: " PROJECT_NAME
done

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

# Delete project
#########################################
echo "Deleting project"
oc delete project $PROJECT_NAME

echo "OK"
