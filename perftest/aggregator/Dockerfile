FROM centos:8

RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y httpd && \
    yum install -y openssh-server && \
    yum install -y java-11-openjdk-devel && \
    yum install -y inotify-tools && \
    yum install -y gcc make unzip && \
    mkdir -p /var/www/html

RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

RUN useradd --create-home --shell /bin/bash -p "$(openssl passwd -1 simpass)" simuser

EXPOSE 80
EXPOSE 22

ADD doaggregate.sh /doaggregate.sh
ADD html /var/www/html
ADD conf/vsftpd.conf /tmp/vsftpd.conf
RUN chmod -v +x /doaggregate.sh

ENTRYPOINT [ "/doaggregate.sh" ]
