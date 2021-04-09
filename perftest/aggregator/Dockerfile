# Build: docker build -t="apicurio/apicurio-perftest-aggregator" --rm .
# Run:   docker run -it apicurio/apicurio-perftest-aggregator --network="host"

#    firewall-cmd --permanent --add-service=http && \
#    firewall-cmd --reload && \

FROM centos:7

RUN yum -y update httpd && \
    useradd --create-home --home-dir /home/webuser --shell /bin/bash --gid root --groups sudo webuser

RUN echo 'webpass123#' | chpasswd

USER newuser
WORKDIR /home/webuser

EXPOSE 8080

RUN sudo systemctl start httpd

ENTRYPOINT [ "/usr/sbin/httpd", "–DFOREGROUND" ]