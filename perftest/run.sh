#!/bin/sh

docker run -e REGISTRY_URL=http://127.0.0.1:9090/apis/registry/v1 --network="host" -it apicurio/apicurio-perftest-load:latest
