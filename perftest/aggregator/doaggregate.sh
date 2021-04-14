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
/usr/sbin/apachectl -DFOREGROUND &

#exec /usr/sbin/apachectl -DFOREGROUND -e debug


echo ""
echo "Watching for simulation log files... (Ctrl-C to stop the aggregator)"
WATCH_DIR=$LOGS_DIR
LOGFILE=/tmp/watchlog.txt

inotifywait -m -e create -e moved_to --format "%f" $WATCH_DIR \
        | while read FILENAME
          do
              echo Detected $FILENAME, processing!
              mv "$WATCH_DIR/$FILENAME" "$HTML_LOGS_DIR/$FILENAME"
          done

#while : ; do

#    ls -al $WATCH_DIR
#    inotifywait $WATCH_DIR -t 600
#    ls -al $WATCH_DIR

#        inotifywait $watchdir | while read path action file; do
#                ts=$(date +"%C%y%m%d%H%M%S")
#                echo "$ts :: file: $file :: $action :: $path"
#                echo "$ts :: file: $file :: $action :: $path">>$logfile
#        done
#done
echo "Done!"
