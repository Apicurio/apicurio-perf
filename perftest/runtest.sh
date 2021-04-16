#!/bin/sh

OCM_API=https://api.stage.openshift.com
REGISTRY_HOST=apicurio-registry-managed-service-registry.apps.srs-reg-mem.0c9j.s1.devshift.org

# Get kube admin credentials
#########################################
echo "Getting kube admin credentials"
CLUSTER_USER=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.user`
CLUSTER_PASSWORD=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.password`

# Login to cluster
#########################################
echo "Logging in to cluster using 'oc login'"
oc login --insecure-skip-tls-verify --username=$CLUSTER_USER --server=$CLUSTER_URL --password=$CLUSTER_PASSWORD

# Install aggregator to cluster
#########################################
echo "Creating project and deploying perftest"
oc new-project registry-perftest
oc apply -f aggregator-deployment.yaml

# Wait for aggregator to be deployed
#########################################
echo "Waiting for aggregator deployment to complete..."
sleep 30
echo "Getting aggregator route/host."
AGGREGATOR_HOST=`oc get route -o json | jq -r .items[0].spec.host`

echo "----------"
echo "Success!"
echo "Aggregator Web: http://$APP_HOST"
echo "----------"

# Update job YAML with env var values
#########################################
mkdir -p target
cat worker-job.yaml | \
   sed "s/REGISTRY_HOST/$REGISTRY_HOST/g" > target/worker-job.yaml

# Run worker jobs
#########################################
echo "Deploying worker job"
oc apply -f target/worker-job.yaml

# Monitor workers
#########################################
oc get pods

# Note: perhaps use kubectl to wait on the job pods to complete
#       kubectl wait --for=condition=complete job/myjob
