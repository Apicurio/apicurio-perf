#!/bin/sh

docker run -p 5080:80 -p 5021:21 -p 10000-10100:10000-10100 -it apicurio/apicurio-perftest-aggregator:latest
