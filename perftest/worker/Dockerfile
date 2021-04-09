# Build: docker build -t="apicurio/apicurio-perftest-worker" --rm .
# Run:   docker run -it apicurio/apicurio-perftest-worker --env REGISTRY_URL=http://127.0.0.1:8080/apis/registry/v1 --network="host"

FROM openjdk:8-jdk-alpine

# working directory for gatling
WORKDIR /opt

# gatling version
ENV GATLING_VERSION 3.5.1

# set environment variables
ENV PATH /opt/gatling/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GATLING_HOME /opt/gatling
ENV REGISTRY_URL http://127.0.0.1:8080/apis/registry/v1
ENV TEST_USERS 10
ENV TEST_RAMP_TIME 30
ENV TEST_REPORT_RESULTS false
ENV TEST_AGGREGATOR_HOST none

# create directory for gatling install
RUN mkdir -p gatling

# install gatling
RUN apk add --update wget bash libc6-compat curl rsync && \
  mkdir -p /tmp/downloads && \
  wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
     https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
  mkdir -p /tmp/archive && cd /tmp/archive && \
  unzip /tmp/downloads/gatling-$GATLING_VERSION.zip && \
  mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /opt/gatling/ && \
  rm -rf /tmp/*

# change context to gatling directory
WORKDIR  /opt/gatling

# add simulations to the docker image
ADD scala /opt/gatling-simulations
ADD dotest.sh /opt/gatling/dotest.sh

# run the test
#ENTRYPOINT ["/opt/gatling/bin/gatling.sh", "-sf", "/opt/gatling-simulations", "-s", "simulations.BasicSimulation"]
ENTRYPOINT ["/opt/gatling/dotest.sh"]
