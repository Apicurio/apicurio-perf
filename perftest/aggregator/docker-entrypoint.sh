#!/bin/sh

export GATLING_VERSION
export GATLING_HOME
export LOGS_DIR
export HTML_DIR
export RESULTS_DIR
export SHELL_PATH
export PROCESS_SH_PATH


echo "-------------------------------------------------------------------------"
echo "Running Apicurio Registry Performance Test (aggregator)"
echo "---"
echo "GATLING_VERSION: $GATLING_VERSION"
echo "GATLING_HOME:    $GATLING_HOME"
echo "LOGS_DIR:        $LOGS_DIR"
echo "HTML_DIR:        $HTML_DIR"
echo "RESULTS_DIR:     $RESULTS_DIR"
echo "SHELL_PATH:      $SHELL_PATH"
echo "PROCESS_SH_PATH: $PROCESS_SH_PATH"
echo "-------------------------------------------------------------------------"

# Install Gatling
mkdir -p $GATLING_HOME
mkdir -p /tmp/downloads
wget -q -O /tmp/downloads/gatling-$GATLING_VERSION.zip https://repo1.maven.org/maven2/io/gatling/highcharts/gatling-charts-highcharts-bundle/$GATLING_VERSION/gatling-charts-highcharts-bundle-$GATLING_VERSION-bundle.zip
mkdir -p /tmp/archive
unzip /tmp/downloads/gatling-$GATLING_VERSION.zip -d /tmp/archive
mv /tmp/archive/gatling-charts-highcharts-bundle-$GATLING_VERSION/* /apps/gatling/
mkdir -p /apps/logs
mkdir -p /apps/www

echo "-----------------------------------"

echo "ls -al / | grep apps"
echo "---"
ls -al / | grep apps
echo "ls -al /apps"
echo "---"
ls -al /apps

echo "Starting aggregator"
/apps/bin/aggregator
