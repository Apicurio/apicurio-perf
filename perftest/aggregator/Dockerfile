FROM centos:8

ENV GATLING_VERSION 3.5.1
ENV GATLING_HOME /apps/gatling

ENV LOGS_DIR /apps/logs
ENV HTML_DIR /apps/www
ENV RESULTS_DIR /apps/gatling/results
ENV SHELL_PATH /bin/bash
ENV PROCESS_SH_PATH /apps/bin/process.sh

EXPOSE 8080

# Install apps
RUN yum update -y && \
    yum install -y wget unzip && \
    yum install -y java-11-openjdk-devel

RUN useradd --create-home --shell /bin/bash -p "$(openssl passwd -1 quarkus)" quarkus
RUN mkdir -p /apps && chown quarkus /apps

USER quarkus

# Install Gatling
RUN mkdir -p $GATLING_HOME && \
    mkdir -p /tmp/downloads && \
    wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
      https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
    mkdir -p /tmp/archive && \
    unzip /tmp/downloads/gatling-$GATLING_VERSION.zip -d /tmp/archive && \
    mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /apps/gatling/ && \
    mkdir -p /apps/bin && mkdir -p /apps/www && mkdir -p /apps/logs


ADD --chown=quarkus process.sh /apps/bin/process.sh
ADD --chown=quarkus target/aggregator /apps/bin/aggregator

ENTRYPOINT [ "/apps/bin/aggregator" ]
