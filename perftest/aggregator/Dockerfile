FROM centos:8

ENV GATLING_VERSION 3.5.1
ENV GATLING_HOME /apps/gatling
ENV HTTPD_HOME=/apps/www
ENV SSHD_HOME=/apps/ssh

EXPOSE 8080
EXPOSE 8022

# Install apps
RUN yum update -y && \
    yum install -y wget unzip httpd && \
    yum install -y openssh-server openssh-clients && \
    yum install -y java-11-openjdk-devel

RUN useradd --create-home --shell /bin/bash -p "$(openssl passwd -1 matt)" matt
RUN useradd --create-home --shell /bin/bash -p "$(openssl passwd -1 simpass)" simuser
RUN mkdir -p /apps && chown matt /apps
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
RUN rm -rf /run/nologin


USER simuser
RUN mkdir -p /home/simuser/logs


USER matt

# Install Gatling
RUN mkdir -p $GATLING_HOME && \
    mkdir -p /tmp/downloads && \
    wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
      https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
    mkdir -p /tmp/archive && \
    unzip /tmp/downloads/gatling-$GATLING_VERSION.zip -d /tmp/archive && \
    mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /opt/gatling/ && \
    mkdir -p /apps/bin && mkdir -p /apps/www/conf


ADD conf/httpd.conf /apps/www/conf/httpd.conf
ADD docker-entrypoint.sh /apps/bin/docker-entrypoint.sh
ADD process.sh /apps/bin/process.sh
ADD html /apps/www/html
RUN chmod -v +x /apps/bin/docker-entrypoint.sh && chmod -v +x /apps/bin/process.sh

ENTRYPOINT [ "/apps/bin/docker-entrypoint.sh" ]
