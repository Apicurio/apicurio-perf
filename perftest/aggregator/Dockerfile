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

USER quarkus

ADD --chown=quarkus docker-entrypoint.sh /apps/bin/docker-entrypoint.sh
ADD --chown=quarkus process.sh /apps/bin/process.sh
ADD --chown=quarkus target/aggregator /apps/bin/aggregator

ENTRYPOINT [ "/apps/bin/docker-entrypoint.sh" ]
