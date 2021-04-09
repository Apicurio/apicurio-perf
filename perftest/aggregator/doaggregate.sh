#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "--------- 1"
/usr/sbin/apachectl -V
echo "--------- 1"

echo "--------- 2"
cat /usr/local/apache2/conf/httpd.conf
echo "--------- 2"

exec /usr/sbin/apachectl -DFOREGROUND -e debug
