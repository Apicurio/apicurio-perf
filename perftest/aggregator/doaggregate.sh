#!/bin/sh

echo "Configuring rsync-daemon"
cp /tmp/rsyncd.conf /etc/rsyncd.conf
mkdir -p /var/www/html/logs

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

echo ""
echo ""
echo ""
echo ""
echo ""

exec /usr/sbin/apachectl -DFOREGROUND

#exec /usr/sbin/apachectl -DFOREGROUND -e debug
