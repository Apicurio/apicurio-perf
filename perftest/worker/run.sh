#!/bin/sh

TEST_SIMULATION=$1

while [ "x$TEST_SIMULATION" = "x" ]
do
  read -p "Simulation: " TEST_SIMULATION
done


docker run --network="host" -it \
    -e REGISTRY_URL=http://127.0.0.1:9090/apis/registry/v1 \
    -e TEST_RAMP_TIME=5 \
    -e TEST_REPORT_RESULTS=true \
    -e TEST_AGGREGATOR_HOST=localhost \
    -e TEST_AGGREGATOR_PORT=5080 \
    -e TEST_SIMULATION=$TEST_SIMULATION \
    apicurio/apicurio-perftest-worker:latest
