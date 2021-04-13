FROM centos:8

RUN yum update -y && \
    yum install -y httpd && \
    yum install -y rsync-daemon && \
    yum install -y java-11-openjdk-devel && \
    yum install -y inotify-tools && \
    mkdir -p /webroot && \
    mkdir -p /var/www/html

EXPOSE 80
EXPOSE 873

ADD doaggregate.sh /doaggregate.sh
ADD html /var/www/html
ADD conf/rsyncd.conf /tmp/rsyncd.conf
RUN chmod -v +x /doaggregate.sh

ENTRYPOINT [ "/doaggregate.sh" ]
