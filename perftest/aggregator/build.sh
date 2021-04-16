#!/bin/sh

pushd .

rm -rf target
mkdir -p target
cd target
git clone git@github.com:EricWittmann/apicurio-perftest-aggregator.git
cd apicurio-perftest-aggregator
mvn package -Pnative -Dquarkus.native.container-build=true

popd
cp target/apicurio-perftest-aggregator/target/apicurio*-runner target/aggregator

docker build -t="apicurio/apicurio-perftest-aggregator" --rm .
