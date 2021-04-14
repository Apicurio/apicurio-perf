#!/bin/sh

export PATH
export GATLING_HOME
export REGISTRY_URL
export TEST_USERS
export TEST_RAMP_TIME
export TEST_REPORT_RESULTS
export TEST_AGGREGATOR_HOST
export TEST_AGGREGATOR_PORT
export TEST_AGGREGATOR_USER
export TEST_AGGREGATOR_PASS

echo "-------------------------------------------------------------------------"
echo "Running Apicurio Registry Performance Test (load generator)"
echo "---"
echo "PATH: $PATH"
echo "GATLING_HOME: $GATLING_HOME"
echo "REGISTRY_URL: $REGISTRY_URL"
echo "TEST_USERS: $TEST_USERS"
echo "TEST_RAMP_TIME: $TEST_RAMP_TIME"
echo "TEST_REPORT_RESULTS: $TEST_REPORT_RESULTS"
echo "TEST_AGGREGATOR_HOST: $TEST_AGGREGATOR_HOST"
echo "TEST_AGGREGATOR_PORT: $TEST_AGGREGATOR_PORT"
echo "TEST_AGGREGATOR_USER: $TEST_AGGREGATOR_USER"
echo "-------------------------------------------------------------------------"

curl $REGISTRY_URL/search/artifacts --fail

cd /opt/gatling
./bin/gatling.sh -nr -sf /opt/gatling-simulations -s simulations.BasicSimulation

echo "Test complete"

if [ "x$TEST_REPORT_RESULTS" = "xtrue" ]
then
  echo "Uploading simulation log..."
  UUID=`cat /proc/sys/kernel/random/uuid`
  LOG_NAME=simulation-$UUID.log
  mv /opt/gatling/results/basicsimulation-*/simulation.log /opt/gatling/reports/$LOG_NAME
  # upload the simulation file
  echo "Uploading the simulation file: $LOG_NAME"
  sshpass -v -p "$TEST_AGGREGATOR_PASS" scp -P $TEST_AGGREGATOR_PORT \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    /opt/gatling/reports/$LOG_NAME \
    $TEST_AGGREGATOR_USER@$TEST_AGGREGATOR_HOST:/home/simuser/logs/$LOG_NAME

  # process the uploaded simulation file
  echo "Generating aggregate report..."
  sshpass -v -p "simpass" ssh -p $TEST_AGGREGATOR_PORT \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    $TEST_AGGREGATOR_USER@$TEST_AGGREGATOR_HOST \
    /process.sh
fi


echo "Done!"
