#!/bin/sh

echo "Configuring rsync-daemon"
cp /tmp/rsyncd.conf /etc/rsyncd.conf
mkdir -p /tmp/logs

echo "Starting rsync-daemon"
systemctl enable --now rsyncd 

rm -rf /run/httpd/* /tmp/httpd*

echo "-------------- cat rsyncd.conf"
cat /etc/rsyncd.conf
echo "--------------"
echo ""
echo ""
echo "-------------- java -version"
java -version
echo "--------------"

#echo "Building and installed inotify-tools"
#mkdir -p /tmp/work
#cd /tmp/work
#curl https://codeload.github.com/inotify-tools/inotify-tools/zip/refs/tags/3.20.11.0 -o /tmp/work/inotify-tools-3.20.11.0.zip
#unzip inotify-tools-3.20.11.0.zip
#cd /tmp/work/inotify-tools-3.20.11.0
#./configure
#make
#make install

echo ""
echo ""
echo "------------------------ inotify"
ls -l /usr/local/bin/inotify*
echo "------------------------"
echo ""

#echo "Starting httpd"
#/usr/sbin/apachectl -DFOREGROUND &

#exec /usr/sbin/apachectl -DFOREGROUND -e debug

echo ""
echo "Watching for simulation log files... (Ctrl-C to stop the aggregator)"
watchdir=/tmp/logs
logfile=/tmp/watchlog.txt
#while : ; do
        inotifywait $watchdir|while read path action file; do
                ts=$(date +"%C%y%m%d%H%M%S")
                echo "$ts :: file: $file :: $action :: $path"
                echo "$ts :: file: $file :: $action :: $path">>$logfile
        done
#done
echo "Done!"
