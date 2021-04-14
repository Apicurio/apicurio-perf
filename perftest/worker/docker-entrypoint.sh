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
  mkdir -p /tmp/uploads
  echo "Uploading simulation log..."

  # Find and stage the simulation.log file into /tmp/uploads
  UUID=`cat /proc/sys/kernel/random/uuid`
  LOG_NAME=simulation-$UUID.log
  UPLOAD_FILE=/tmp/uploads/$LOG_NAME
  find /opt/gatling/results/ -name 'simulation.log' -exec cp {} $UPLOAD_FILE \;

  # upload the simulation file
  echo "Uploading the simulation file: $UPLOAD_FILE"
  sshpass -v -p "$TEST_AGGREGATOR_PASS" scp -P $TEST_AGGREGATOR_PORT \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    $UPLOAD_FILE \
    $TEST_AGGREGATOR_USER@$TEST_AGGREGATOR_HOST:/home/simuser/logs/$LOG_NAME

  # process the uploaded simulation file
  echo "Generating aggregate report..."
  sshpass -v -p "simpass" ssh -p $TEST_AGGREGATOR_PORT \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    $TEST_AGGREGATOR_USER@$TEST_AGGREGATOR_HOST \
    /process.sh
fi

echo "Simulation run complete."