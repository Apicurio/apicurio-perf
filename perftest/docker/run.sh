#!/bin/sh

export PATH
export GATLING_HOME
export REGISTRY_URL
export TEST_USERS
export TEST_RAMP_TIME
export TEST_REPORT_RESULTS
export TEST_AGGREGATOR_HOST

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
echo "-------------------------------------------------------------------------"


cd /opt/gatling
./bin/gatling.sh -nr -sf /opt/gatling-simulations -s simulations.BasicSimulation

echo "Test complete"

if [ "x$TEST_REPORT_RESULTS" = "xtrue"]
then
  echo "Uploading simulation log..."
  UUID=`cat /proc/sys/kernel/random/uuid`
  mv /opt/gatling/reports/simulation.log /opt/gatling/reports/simulation-$UUID.log
fi

echo "Done!"
