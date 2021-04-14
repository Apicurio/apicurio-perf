FROM centos:8

# gatling version
ENV GATLING_VERSION 3.5.1
ENV GATLING_HOME /opt/gatling


RUN yum update -y && \
    yum install -y wget unzip httpd && \
    yum install -y openssh-server openssh-clients && \
    yum install -y java-11-openjdk-devel && \
    mkdir -p $GATLING_HOME && \
    mkdir -p /tmp/downloads && \
    wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip \
      https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip && \
    mkdir -p /tmp/archive && \
    unzip /tmp/downloads/gatling-$GATLING_VERSION.zip -d /tmp/archive && \
    mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /opt/gatling/ && \
    mkdir -p /var/www/html

RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

RUN useradd --create-home --shell /bin/bash -p "$(openssl passwd -1 simpass)" simuser

RUN rm -rf /run/nologin

EXPOSE 80
EXPOSE 22

ADD docker-entrypoint.sh /docker-entrypoint.sh
ADD process.sh /process.sh
ADD html /var/www/html
RUN chmod -v +x /docker-entrypoint.sh && chmod -v +x /process.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]
