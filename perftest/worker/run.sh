#!/bin/sh

export REGISTRY_URL=http://127.0.0.1:9090/apis/registry/v1
export TEST_RAMP_TIME=5
export TEST_REPORT_RESULTS=true
export TEST_AGGREGATOR_HOST=localhost
export TEST_AGGREGATOR_PORT=5022

docker run --network="host" -it apicurio/apicurio-perftest-worker:latest
