# Build: docker build -t="apicurio/apicurio-perftest-aggregator" --rm .
# Run:   docker run -it apicurio/apicurio-perftest-aggregator --network="host"

#    firewall-cmd --permanent --add-service=http && \
#    firewall-cmd --reload && \

FROM centos:7

RUN yum -y update httpd

EXPOSE 8080

RUN systemctl start httpd

ENTRYPOINT [ "/usr/sbin/httpd", "–DFOREGROUND" ]
