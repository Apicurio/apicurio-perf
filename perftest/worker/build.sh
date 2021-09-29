#!/bin/sh

pushd .
cd token-refresh
mvn clean package
popd

docker build -t="apicurio/apicurio-perftest-worker" --rm .
