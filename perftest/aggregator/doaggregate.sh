#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "---------------------"
/usr/sbin/httpd --help
echo "---------------------"

echo "exec /usr/sbin/apachectl -DFOREGROUND"
