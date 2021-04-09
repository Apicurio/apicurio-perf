#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "---------------------"
/usr/sbin/apachectl --help
echo "---------------------"

exec /usr/sbin/apachectl -DFOREGROUND
