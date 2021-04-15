#!/bin/sh

GATLING_HOME=/apps/gatling
LOGS_DIR=/apps/logs
HTML_LOGS_DIR=/apps/www/logs
RESULTS_DIR=$GATLING_HOME/results

echo "Copying log files from $LOGS_DIR to $HTML_LOGS_DIR"
mkdir -p $HTML_LOGS_DIR
cp -f $LOGS_DIR/*.log $HTML_LOGS_DIR

echo "Copying log files from $LOGS_DIR to $RESULTS_DIR/aggregate"
mkdir -p $RESULTS_DIR/aggregate
cp -f $LOGS_DIR/*.log $RESULTS_DIR/aggregate/

echo "Generating aggregate simulation report..."
cd /apps/gatling
./bin/gatling.sh -ro aggregate

echo "Copying generated report to web results folder"
cp -rf $RESULTS_DIR/aggregate/* /apps/www/

echo "Aggregate report generated."
