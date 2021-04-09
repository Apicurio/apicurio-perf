#!/bin/sh

cd /opt/gatling
./bin/gatling.sh -nr -sf /opt/gatling-simulations -s simulations.BasicSimulation

echo "Test complete"

if [ "x$TEST_REPORT_RESULTS" = "xtrue"]
then
  echo "Uploading simulation log..."
  UUID=`cat /proc/sys/kernel/random/uuid`
  mv /opt/gatling/reports/simulation.log /opt/gatling/reports/simulation-$UUID.log
fi

echo "Done!"
