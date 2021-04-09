# Build: docker build -t="apicurio/apicurio-perftest-aggregator" --rm .
# Run:   docker run -it apicurio/apicurio-perftest-aggregator --network="host"

#    firewall-cmd --permanent --add-service=http && \
#    firewall-cmd --reload && \

FROM centos:7

RUN yum update -y && \
    yum install -y httpd

EXPOSE 80

CMD [ "find", "/", "-name", "httpd" ]

ENTRYPOINT [ "/usr/sbin/httpd", "–DFOREGROUND" ]
