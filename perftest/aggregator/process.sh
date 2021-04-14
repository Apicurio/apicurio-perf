#!/bin/sh

LOGS_DIR=/home/simuser/logs
HTML_LOGS_DIR=/var/www/html/logs
RESULTS_DIR=$GATLING_HOME/results

echo "Copying log files from $LOGS_DIR to $HTML_LOGS_DIR"
cp -f $LOGS_DIR/*.log $HTML_LOGS_DIR

echo "Copying log files from $LOGS_DIR to $RESULTS_DIR/aggregate"
mkdir -p $RESULTS_DIR/aggregate
cp -f $LOGS_DIR/*.log $RESULTS_DIR/aggregate

echo "Generating aggregate simulation report..."
cd /opt/gatling
./bin/gatling.sh -ro aggregate

find $GATLING_HOME -name '*.htm*'

echo "Done!"
