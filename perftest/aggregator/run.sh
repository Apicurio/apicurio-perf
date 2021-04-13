#!/bin/sh

docker run -p 5080:80 -p 5022:22 -it apicurio/apicurio-perftest-aggregator:latest
