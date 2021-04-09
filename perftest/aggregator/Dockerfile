# Build: docker build -t="apicurio/apicurio-perftest-aggregator" --rm .
# Run:   docker run -it apicurio/apicurio-perftest-aggregator --network="host"

#    firewall-cmd --permanent --add-service=http && \
#    firewall-cmd --reload && \

FROM centos:8

RUN yum update -y && \
    yum install -y httpd && \
    mkdir -p /webroot && \
    mkdir -p /var/www/html

EXPOSE 80

ADD doaggregate.sh /doaggregate.sh
ADD html /var/www/html
RUN chmod -v +x /doaggregate.sh

ENTRYPOINT [ "/doaggregate.sh" ]
