FROM centos:8

# gatling version
ENV GATLING_VERSION 3.5.1

# set environment variables
ENV GATLING_HOME /apps/gatling
ENV REGISTRY_URL http://127.0.0.1:8080/apis/registry/v1
ENV TEST_USERS 10
ENV TEST_RAMP_TIME 30
ENV TEST_REPORT_RESULTS false
ENV TEST_AGGREGATOR_HOST none
ENV TEST_AGGREGATOR_PORT 80

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y curl wget unzip zip && \
    yum install -y java-11-openjdk-devel && \
    useradd --create-home --shell /bin/bash -p "$(openssl passwd -1 worker)" worker && \
    mkdir -p /apps && chown worker /apps

USER worker

# Install Gatling
RUN mkdir -p $GATLING_HOME && \
    mkdir -p /tmp/downloads && \
    wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
      https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
    mkdir -p /tmp/archive && \
    unzip /tmp/downloads/gatling-$GATLING_VERSION.zip -d /tmp/archive && \
    mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /apps/gatling/ && \
    mkdir -p /apps/bin

# change context to gatling directory
WORKDIR  /opt/gatling

# add simulations to the docker image
ADD --chown=worker scala /apps/gatling/simulations
ADD --chown=worker docker-entrypoint.sh /apps/bin/docker-entrypoint.sh
RUN chown -R worker /apps && chmod -R 777 /apps

# run the test
ENTRYPOINT ["/apps/bin/docker-entrypoint.sh"]
