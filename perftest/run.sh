#!/bin/sh

docker run -it apicurio/apicurio-perftest-load:latest --env REGISTRY_URL=http://127.0.0.1:9090/apis/registry/v1 --network="host"
