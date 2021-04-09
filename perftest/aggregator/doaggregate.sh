#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "--------- 1"
/usr/sbin/apachectl -V
echo "--------- 1"

echo "--------- 2"
cat /etc/httpd/conf/httpd.conf
echo "--------- 2"

echo ""
echo ""
echo ""
echo ""
echo ""

exec /usr/sbin/apachectl -DFOREGROUND -e debug
