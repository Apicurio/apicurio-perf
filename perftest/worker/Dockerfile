FROM quay.io/centos/centos:8

# gatling version
ENV GATLING_VERSION 3.5.1

# token refresh version
ENV TOKEN_REFRESH_VERSION 1.0

# set environment variables
ENV GATLING_HOME /apps/gatling

ENV OCM_PATH /apps/bin/ocm
ENV OCM_URL staging
ENV OFFLINE_TOKEN not-provided

ENV TOKEN_URL https://identity.api.stage.openshift.com/auth/realms/rhoas/protocol/openid-connect/token
ENV ADMIN_CLIENT_ID not-provided
ENV ADMIN_CLIENT_SECRET not-provided

ENV DEV_CLIENT_ID not-provided
ENV DEV_CLIENT_SECRET not-provided

ENV FLEET_MANAGER_URL https://api.stage.openshift.com/api/serviceregistry_mgmt
ENV REGISTRY_URL http://127.0.0.1:8080/apis/registry/v2

ENV TEST_SIMULATION BasicSimulation
ENV TEST_USERS 10
ENV TEST_RAMP_TIME 30
ENV TEST_REPORT_RESULTS false
ENV TEST_AGGREGATOR_HOST none
ENV TEST_AGGREGATOR_PORT 80

ENV TEST_RESULTS_GITHUB_USER apicurio-ci
ENV TEST_RESULTS_GITHUB_EMAIL apicurio.ci@gmail.com
ENV TEST_RESULTS_GITHUB_PASS not-provided

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y curl wget unzip zip git && \
    yum install -y java-11-openjdk-devel

RUN useradd --create-home --shell /bin/bash worker && mkdir -p /apps && chown worker /apps

# Install maven
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz https://archive.apache.org/dist/maven/maven-3/3.8.4/binaries/apache-maven-3.8.4-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

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

# Install ocm
RUN curl -Lso /apps/bin/ocm https://github.com/openshift-online/ocm-cli/releases/download/v0.1.42/ocm-linux-amd64 && \
    chmod +x /apps/bin/ocm

# Setup token-refresh library
RUN mvn --version && java -version
ADD --chown=worker token-refresh /tmp/token-refresh
WORKDIR /tmp/token-refresh
RUN mvn clean package
RUN cp -r /tmp/token-refresh/target/apicurio-perf-token-refresh-$TOKEN_REFRESH_VERSION.jar /apps/gatling/lib
RUN cp -r /tmp/token-refresh/target/lib/*.jar /apps/gatling/lib

# change context to gatling directory
WORKDIR  /opt/gatling

# add simulations to the docker image
ADD --chown=worker scala /apps/gatling/simulations
ADD --chown=worker docker-entrypoint.sh /apps/bin/docker-entrypoint.sh
ADD --chown=worker conf /apps/gatling/conf

RUN chown -R worker /apps && chmod -R 777 /apps

# permissions to the root group, for running this on openshift
USER root
RUN chgrp -R 0 /home/worker && \
    chmod -R g=u /home/worker
RUN chgrp -R 0 /opt/gatling && \
  chmod -R g=u /opt/gatling
RUN chgrp -R 0 /apps/gatling/simulations && \
    chmod -R g=u /apps/gatling/simulations
RUN chgrp -R 0 /apps/gatling/conf && \
    chmod -R g=u /apps/gatling/conf
RUN echo "{}" >> /.ocm.json
RUN chgrp -R 0 /.ocm.json && \
    chmod -R g=u /.ocm.json
USER worker

# run the test
ENTRYPOINT ["/apps/bin/docker-entrypoint.sh"]
