#!/bin/sh

# to fail fast if any commands fail
set -e

OCM_API=https://api.stage.openshift.com

if [[ $CLUSTER_URL == "" ]]
then
  echo "ERROR: Missing CLUSTER_URL env variable"
  exit 1
fi

while [ "x$REGISTRY_HOST" = "x" ]
do
  read -p "Registry Host: " REGISTRY_HOST
done
while [ "x$TEST_SIMULATION" = "x" ]
do
  read -p "Simulation: " TEST_SIMULATION
done
while [ "x$TEST_ITERATIONS" = "x" ]
do
  read -p "Iterations: " TEST_ITERATIONS
done
while [ "x$TEST_USERS" = "x" ]
do
  read -p "Number of Test Users: " TEST_USERS
done
while [ "x$TEST_RAMP_TIME" = "x" ]
do
  read -p "Ramp up Time (seconds): " TEST_RAMP_TIME
done
while [ "x$TEST_WORKERS" = "x" ]
do
  read -p "Number of Workers: " TEST_WORKERS
done

# Get kube admin credentials
#########################################
if [[ $CLUSTER_USER == "" ]]
then
  echo "Getting kube admin credentials"
  CLUSTER_USER=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.user`
  CLUSTER_PASSWORD=`ocm get $OCM_API/api/clusters_mgmt/v1/clusters/$CLUSTER_ID/credentials | jq -r .admin.password`
fi

if [[ $CLUSTER_USER == "" ]]
then
  echo "ERROR: Missing CLUSTER_USER and CLUSTER_PASSWORD env variables"
  exit 1
fi

# Login to cluster
#########################################
echo "Logging in to cluster using 'oc login'"
oc login --insecure-skip-tls-verify --username=$CLUSTER_USER --server=$CLUSTER_URL --password=$CLUSTER_PASSWORD

# Install aggregator to cluster
#########################################
echo "Creating project and deploying perftest"
oc new-project registry-perftest || oc project registry-perftest
oc apply -f aggregator-deployment.yaml

# Wait for aggregator to be deployed
#########################################
echo "Waiting for aggregator deployment to complete..."
sleep 5
oc wait --for=condition=available deployment/apicurio-perftest --timeout=60s
echo "Getting aggregator route/host."
AGGREGATOR_HOST=`oc get route -o json | jq -r .items[0].spec.host`

echo "----------"
echo "Aggregator successfully deployed!"
echo "Aggregate command: curl -X PUT http://$AGGREGATOR_HOST/api/aggregator/commands/aggregate"
echo "Aggregator Report: http://$AGGREGATOR_HOST/w/report"
echo "----------"

# Update job YAML with env var values
#########################################
mkdir -p target
cat worker-job.yaml | \
   sed "s/REGISTRY_HOST/$REGISTRY_HOST/g" | \
   sed "s/TEST_SIMULATION_VALUE/$TEST_SIMULATION/g" | \
   sed "s/TEST_WORKERS/$TEST_WORKERS/g" | \
   sed "s/TEST_WORKERS/$TEST_WORKERS/g" | \
   sed "s/TEST_ITERATIONS_VALUE/$TEST_ITERATIONS/g" | \
   sed "s/TEST_USERS_VALUE/$TEST_USERS/g" | \
   sed "s/TEST_RAMP_TIME_VALUE/$TEST_RAMP_TIME/g" > target/worker-job.yaml


# Run worker jobs
#########################################
echo "Deploying job"
oc apply -f target/worker-job.yaml

# Monitor workers
#########################################
echo "Job deployed"
oc get pods
sleep 5
echo "Waiting for job to complete..."
sleep 10
oc wait --for=condition=complete job/worker --timeout=45m

# Aggregate results
#########################################
echo "Aggregating results..."
curl -X PUT http://$AGGREGATOR_HOST/api/aggregator/commands/aggregate

echo "Done!"

echo "View the report: http://$AGGREGATOR_HOST/w/report"
