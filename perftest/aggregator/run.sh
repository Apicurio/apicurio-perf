#!/bin/sh

docker run -p 5080:80 -p 5021:21 -it apicurio/apicurio-perftest-aggregator:latest
