#!/bin/sh

OCM_API=https://api.stage.openshift.com

while [ "x$CLUSTER_ID" = "x" ]
do
  read -p "OCM Test Cluster Name: " CLUSTER_NAME
  CLUSTER_ID=`ocm get "$OCM_API/api/clusters_mgmt/v1/clusters" | jq -r "(.items[] | select(.name | contains(\"$CLUSTER_NAME\"))).id"`
  [[ $CLUSTER_ID =~ ^null$ ]] && CLUSTER_ID=""
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
