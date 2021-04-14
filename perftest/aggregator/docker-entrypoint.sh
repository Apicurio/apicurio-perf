#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

LOGS_DIR=/home/simuser/logs
HTML_LOGS_DIR=/var/www/html/logs

mkdir -p $LOGS_DIR

echo "-------------- java -version"
java -version
echo "--------------"

echo "Configuring upload directory"
mkdir -p $LOGS_DIR
chown simuser $LOGS_DIR

echo "Configuring sshd"

if [ ! -f "/etc/ssh/ssh_host_rsa_key" ]; then
	# generate fresh rsa key
	ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
fi
if [ ! -f "/etc/ssh/ssh_host_dsa_key" ]; then
	# generate fresh dsa key
	ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
fi
if [ ! -f "/etc/ssh/ssh_host_ecdsa_key" ]; then
	# generate fresh ecdsa key
	ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa
fi
if [ ! -f "/etc/ssh/ssh_host_ed25519_key" ]; then
	# generate fresh ed25519 key
	ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519
fi

#prepare run dir
if [ ! -d "/var/run/sshd" ]; then
  mkdir -p /var/run/sshd
fi

echo "Starting SSH server"
/usr/sbin/sshd -D &

echo "Starting httpd"
/usr/sbin/apachectl -DFOREGROUND
