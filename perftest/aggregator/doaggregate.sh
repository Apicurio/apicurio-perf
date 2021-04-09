#!/bin/sh

rm -rf /run/httpd/* /tmp/httpd*

echo "--------------"
cat /etc/rsyncd.conf
echo "--------------"

echo ""
echo ""
echo ""
echo ""
echo ""

exec /usr/sbin/apachectl -DFOREGROUND -e debug
