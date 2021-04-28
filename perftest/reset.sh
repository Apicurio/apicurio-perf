#!/bin/sh

OCM_API=https://api.stage.openshift.com

while [ "x$CLUSTER_ID" = "x" ]
do
  read -p "Cluster ID: " CLUSTER_ID
done


# Get kube admin credentials
#########################################
echo "Getting kube admin credentials"
CLUSTER_USER=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.user`
CLUSTER_PASSWORD=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.password`

# Login to cluster
#########################################
echo "Logging in to cluster using 'oc login'"
oc login --insecure-skip-tls-verify --username=$CLUSTER_USER --server=$CLUSTER_URL --password=$CLUSTER_PASSWORD

oc delete project registry-perftest
