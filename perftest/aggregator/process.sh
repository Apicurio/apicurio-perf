#!/bin/sh

while [ "x$GATLING_HOME" = "x" ]
do
  GATLING_HOME=/apps/gatling
done

while [ "x$LOGS_DIR" = "x" ]
do
  LOGS_DIR=/apps/logs
done

while [ "x$HTML_DIR" = "x" ]
do
  HTML_DIR=/apps/www
done

while [ "x$RESULTS_DIR" = "x" ]
do
  RESULTS_DIR=$GATLING_HOME/results
done

echo "Unpacking log ZIP files in $LOGS_DIR"
cd $LOGS_DIR
ls -al
find . -name '*.zip' -exec unzip {} \;
ls -al

echo "Copying log files from $LOGS_DIR to $HTML_DIR/logs"
zip $HTML_DIR/logs.zip *.log
ls -al $HTML_DIR

echo "Copying log files from $LOGS_DIR to $RESULTS_DIR/aggregate"
mkdir -p $RESULTS_DIR/aggregate
cp -f $LOGS_DIR/*.log $RESULTS_DIR/aggregate/

echo "-------------------------------------"
echo "Aggregating simulation report from the following files:"
ls -al $RESULTS_DIR/aggregate/
echo "-------------------------------------"

echo "Generating aggregate simulation report..."
cd /apps/gatling
./bin/gatling.sh -ro aggregate

echo "Copying generated report to web results folder"
mkdir -p $HTML_DIR/report
cp -rf $RESULTS_DIR/aggregate/* $HTML_DIR/report/

echo "Listing files in $HTML_DIR/report/"
find $HTML_DIR/report/

echo "Aggregate report generated."
