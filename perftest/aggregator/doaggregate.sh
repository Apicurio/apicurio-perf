#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "-------------- cat /etc/vsftpd/vsftpd.conf"
cat /etc/vsftpd/vsftpd.conf
echo "--------------"
echo ""
echo ""
echo "-------------- java -version"
java -version
echo "--------------"

echo "Starting FTP server"
vsftpd --help
vsftpd --version

#echo "Starting httpd"
#/usr/sbin/apachectl -DFOREGROUND &

#exec /usr/sbin/apachectl -DFOREGROUND -e debug

echo ""
echo "Watching for simulation log files... (Ctrl-C to stop the aggregator)"
WATCH_DIR=/tmp/logs
LOGFILE=/tmp/watchlog.txt
#while : ; do
    ls -al /tmp/logs
    inotifywait $WATCH_DIR -t 5
    sleep 5

    ls -al /tmp/logs
    inotifywait $WATCH_DIR -t 5
    sleep 5

    ls -al /tmp/logs
    inotifywait $WATCH_DIR -t 5
    sleep 5

#        inotifywait $watchdir | while read path action file; do
#                ts=$(date +"%C%y%m%d%H%M%S")
#                echo "$ts :: file: $file :: $action :: $path"
#                echo "$ts :: file: $file :: $action :: $path">>$logfile
#        done
#done
echo "Done!"
