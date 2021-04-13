#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

mkdir -p /tmp/logs
mkdir -p /srv/ftp/

echo "-------------- cat /etc/vsftpd/vsftpd.conf"
cp /tmp/vsftpd.conf /etc/vsftpd/vsftpd.conf
cat /etc/vsftpd/vsftpd.conf
echo "--------------"
echo ""
echo ""
echo "-------------- java -version"
java -version
echo "--------------"

echo "Starting FTP server"
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf &

#echo "Starting httpd"
#/usr/sbin/apachectl -DFOREGROUND &

#exec /usr/sbin/apachectl -DFOREGROUND -e debug

echo "Started FTP server!" >> /var/log/xferlog

echo "Tailing the ftp log!"
tail -f /var/log/xferlog

echo ""
echo "Watching for simulation log files... (Ctrl-C to stop the aggregator)"
WATCH_DIR=/srv/ftp/
LOGFILE=/tmp/watchlog.txt
#while : ; do
    ls -al /srv/ftp/
    inotifywait $WATCH_DIR -t 5
    sleep 5

    ls -al /srv/ftp/
    inotifywait $WATCH_DIR -t 5
    sleep 5

    ls -al /srv/ftp/
    inotifywait $WATCH_DIR -t 5
    sleep 5

#        inotifywait $watchdir | while read path action file; do
#                ts=$(date +"%C%y%m%d%H%M%S")
#                echo "$ts :: file: $file :: $action :: $path"
#                echo "$ts :: file: $file :: $action :: $path">>$logfile
#        done
#done
echo "Done!"
