#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "-------------- java -version"
java -version
echo "--------------"

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
/usr/sbin/sshd -D

#echo "Starting httpd"
#/usr/sbin/apachectl -DFOREGROUND &

#exec /usr/sbin/apachectl -DFOREGROUND -e debug

echo "Ctrl-C to stop..." >> /tmp/msg.log
tail -f /tmp/msg.log


echo ""
echo "Watching for simulation log files... (Ctrl-C to stop the aggregator)"
#WATCH_DIR=/srv/ftp/
#LOGFILE=/tmp/watchlog.txt
#while : ; do

#    ls -al /srv/ftp/
#    inotifywait $WATCH_DIR -t 5
#    sleep 5

#        inotifywait $watchdir | while read path action file; do
#                ts=$(date +"%C%y%m%d%H%M%S")
#                echo "$ts :: file: $file :: $action :: $path"
#                echo "$ts :: file: $file :: $action :: $path">>$logfile
#        done
#done
echo "Done!"
