#!/bin/sh

docker run -p 5050:80 -p 8873:873 -it apicurio/apicurio-perftest-aggregator:latest
