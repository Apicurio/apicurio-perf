#!/bin/sh

LOGS_DIR=/home/simuser/logs
HTML_LOGS_DIR=/var/www/html/logs

echo "Copying log files from $LOGS_DIR to $HTML_LOGS_DIR"
cp -f $LOGS_DIR/*.log $HTML_LOGS_DIR
