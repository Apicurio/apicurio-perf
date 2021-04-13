#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "-------------- java -version"
java -version
echo "--------------"

echo "Starting SSH server"
sshd &

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
