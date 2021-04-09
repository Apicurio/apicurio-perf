#!/bin/sh

docker run -e REGISTRY_URL=http://127.0.0.1:9090/apis/registry/v1 -e TEST_RAMP_TIME=5 --network="host" -it apicurio/apicurio-perftest-worker:latest
