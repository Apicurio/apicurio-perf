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

RUN groupadd quarkus
RUN useradd --create-home --gid quarkus --shell /bin/bash -p "$(openssl passwd -1 quarkus)" quarkus
RUN mkdir -p /apps/bin
RUN chown -R quarkus /apps
RUN chgrp -R quarkus /apps

USER quarkus

RUN ls -al / | grep apps
RUN ls -al /apps

ADD --chown=quarkus:quarkus docker-entrypoint.sh /apps/bin/docker-entrypoint.sh
ADD --chown=quarkus:quarkus process.sh /apps/bin/process.sh
ADD --chown=quarkus:quarkus target/aggregator /apps/bin/aggregator

ENTRYPOINT [ "/apps/bin/docker-entrypoint.sh" ]
