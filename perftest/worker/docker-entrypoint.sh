#!/bin/sh

export PATH
export GATLING_HOME
export REGISTRY_URL
export TEST_SIMULATION
export TEST_USERS
export TEST_RAMP_TIME
export TEST_REPORT_RESULTS
export TEST_AGGREGATOR_HOST
export TEST_AGGREGATOR_PORT

echo "-------------------------------------------------------------------------"
echo "Running Apicurio Registry Performance Test (load generator)"
echo "---"
echo "PATH: $PATH"
echo "GATLING_HOME: $GATLING_HOME"
echo "REGISTRY_URL: $REGISTRY_URL"
echo "TEST_SIMULATION: $TEST_SIMULATION"
echo "TEST_USERS: $TEST_USERS"
echo "TEST_RAMP_TIME: $TEST_RAMP_TIME"
echo "TEST_REPORT_RESULTS: $TEST_REPORT_RESULTS"
echo "TEST_AGGREGATOR_HOST: $TEST_AGGREGATOR_HOST"
echo "TEST_AGGREGATOR_PORT: $TEST_AGGREGATOR_PORT"
echo "-------------------------------------------------------------------------"

curl $REGISTRY_URL/search/artifacts --fail

cd /apps/gatling
./bin/gatling.sh -nr -sf /apps/gatling/simulations -s simulations.$TEST_SIMULATION

echo "Test complete"

if [ "x$TEST_REPORT_RESULTS" = "xtrue" ]
then
  mkdir -p /tmp/uploads
  echo "Uploading simulation log..."

  # Find and stage the simulation.log file into /tmp/uploads
  UUID=`cat /proc/sys/kernel/random/uuid`
  LOG_NAME=simulation-$UUID.log
  UPLOAD_FILE=/tmp/uploads/$LOG_NAME
  echo "---"
  find /apps/gatling/ | grep log
  echo "---"
  find /apps/gatling/results/ -name 'simulation.log' -exec cp {} $UPLOAD_FILE \;

  # upload the simulation file
  echo "Uploading the simulation file: $UPLOAD_FILE"
  curl -X POST -H "Content-Type: text/plain" http://$TEST_AGGREGATOR_HOST:$TEST_AGGREGATOR_PORT/api/aggregator/logs/$LOG_NAME --data-binary @$UPLOAD_FILE

  # process the uploaded simulation file
  echo "Generating aggregate report..."
  curl -X PUT http://$TEST_AGGREGATOR_HOST:$TEST_AGGREGATOR_PORT/api/aggregator/commands/aggregate
fi

echo "Simulation run complete."