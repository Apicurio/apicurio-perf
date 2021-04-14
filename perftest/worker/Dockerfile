FROM centos:8

# gatling version
ENV GATLING_VERSION 3.5.1

# set environment variables
ENV GATLING_HOME /opt/gatling
ENV REGISTRY_URL http://127.0.0.1:8080/apis/registry/v1
ENV TEST_USERS 10
ENV TEST_RAMP_TIME 30
ENV TEST_REPORT_RESULTS false
ENV TEST_AGGREGATOR_HOST none
ENV TEST_AGGREGATOR_PORT 22
ENV TEST_AGGREGATOR_USER simuser
ENV TEST_AGGREGATOR_PASS simpass

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y curl wget unzip zip && \
    yum install -y openssh-clients sshpass && \
    yum install -y java-11-openjdk-devel && \
    mkdir -p /tmp/downloads && \
    wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
       https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
    mkdir -p /tmp/archive && cd /tmp/archive && \
    unzip /tmp/downloads/gatling-$GATLING_VERSION.zip && \
    mkdir -p /opt/gatling && \
    mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /opt/gatling/ && \
    rm -rf /tmp/archive /tmp/downloads

# change context to gatling directory
WORKDIR  /opt/gatling

# add simulations to the docker image
ADD scala /opt/gatling-simulations
ADD docker-entrypoint.sh /opt/gatling/docker-entrypoint.sh

# run the test
ENTRYPOINT ["/opt/gatling/docker-entrypoint.sh"]
