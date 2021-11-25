#!/bin/sh

export PATH
export GATLING_HOME
export REGISTRY_URL
export FLEET_MANAGER_URL

export OCM_URL
export OFFLINE_TOKEN

export TOKEN_URL
export ADMIN_CLIENT_ID
export ADMIN_CLIENT_SECRET
export DEV_CLIENT_ID
export DEV_CLIENT_SECRET

export TEST_SIMULATION
export TEST_USERS
export TEST_RAMP_TIME
export TEST_ITERATIONS
export TEST_REPORT_RESULTS
export TEST_AGGREGATOR_HOST
export TEST_AGGREGATOR_PORT

export TEST_SKIP_PUSH_RESULTS_GITHUB
export TEST_RESULTS_GITHUB_REPO
export TEST_RESULTS_GITHUB_USER
export TEST_RESULTS_GITHUB_EMAIL
export TEST_RESULTS_GITHUB_PASS


echo "-------------------------------------------------------------------------"
echo "Running Apicurio Registry Performance Test (load generator)"
echo "---"
echo "PATH: $PATH"
echo "GATLING_HOME: $GATLING_HOME"
echo "TOKEN_URL: $TOKEN_URL"
echo "ADMIN_CLIENT_ID: $ADMIN_CLIENT_ID"
echo "ADMIN_CLIENT_SECRET: xxxxxxxx"
echo "DEV_CLIENT_ID: $DEV_CLIENT_ID"
echo "DEV_CLIENT_SECRET: xxxxxxxx"
echo "REGISTRY_URL: $REGISTRY_URL"
echo "OCM_URL: $OCM_URL"
echo "OFFLINE_TOKEN: $OFFLINE_TOKEN"
echo "FLEET_MANAGER_URL: $FLEET_MANAGER_URL"
echo "TEST_SIMULATION: $TEST_SIMULATION"
echo "TEST_USERS: $TEST_USERS"
echo "TEST_RAMP_TIME: $TEST_RAMP_TIME"
echo "TEST_ITERATIONS: $TEST_ITERATIONS"
echo "TEST_REPORT_RESULTS: $TEST_REPORT_RESULTS"
echo "TEST_AGGREGATOR_HOST: $TEST_AGGREGATOR_HOST"
echo "TEST_AGGREGATOR_PORT: $TEST_AGGREGATOR_PORT"
echo "TEST_SKIP_PUSH_RESULTS_GITHUB: $TEST_SKIP_PUSH_RESULTS_GITHUB"
echo "TEST_RESULTS_GITHUB_REPO: $TEST_RESULTS_GITHUB_REPO"
echo "TEST_RESULTS_GITHUB_USER: $TEST_RESULTS_GITHUB_USER"
echo "TEST_RESULTS_GITHUB_EMAIL: $TEST_RESULTS_GITHUB_EMAIL"
echo "-------------------------------------------------------------------------"

UUID=`cat /proc/sys/kernel/random/uuid`

pwd
ls

echo "-------------------------------------------------------------------------"
/apps/bin/ocm login --url=staging --token=$OFFLINE_TOKEN
/apps/bin/ocm whoami
echo "-------------------------------------------------------------------------"

# Report that the worker has started (report to aggregator).
if [ "x$TEST_REPORT_RESULTS" = "xtrue" ]
then
  echo "---"
  echo "Reporting worker is starting..."
  curl -X PUT http://$TEST_AGGREGATOR_HOST:$TEST_AGGREGATOR_PORT/api/aggregator/workers/$UUID/start --fail
fi

# Run the Gatling test
cd /apps/gatling
./bin/gatling.sh -sf /apps/gatling/simulations -s simulations.$TEST_SIMULATION

# Version that doesn't generate a report (simulation.log file only):
# ./bin/gatling.sh -nr -sf /apps/gatling/simulations -s simulations.$TEST_SIMULATION

echo "Test complete"


# Push the results to github
if [[ -z $TEST_RESULTS_GITHUB_REPO ]] ;
then
  echo "Skipping pushing results via git, missing github repo"
else
  if [ "x$TEST_SKIP_PUSH_RESULTS_GITHUB" = "xtrue" ]
  then
    echo "Skipping pushing results via git, explicitly set"
  else
    echo "Pushing results to $TEST_RESULTS_GITHUB_REPO"
    mkdir -p /tmp/gitwork
    cd /tmp/gitwork
    git init
    git config --global user.name "$TEST_RESULTS_GITHUB_USER"
    git config --global user.email "$TEST_RESULTS_GITHUB_EMAIL"
    git remote add origin "https://$TEST_RESULTS_GITHUB_USER:$TEST_RESULTS_GITHUB_PASS@github.com/Apicurio/$TEST_RESULTS_GITHUB_REPO.git"
    git fetch
    git checkout main
    git branch --set-upstream-to=origin/main
    git pull

    DATESTAMP=`date +"%Y-%m-%d"`
    TIMESTAMP=`date -u +"%H.%M.%S"`
    REPORT_PATH=$DATESTAMP/$TEST_SIMULATION/$TIMESTAMP-${TEST_USERS}u-${TEST_ITERATIONS}i
    FULL_REPORT_PATH=/tmp/gitwork/$REPORT_PATH

    mkdir -p /tmp/gitwork/$REPORT_PATH
    cd /tmp/gitwork/$REPORT_PATH
    echo "---"
    pwd
    echo "---"

    # Find and stage the simulation.log file
    SIMULATION_LOG=`find /apps/gatling/results/ -name 'simulation.log'`
    RESULTS_DIR=`dirname $SIMULATION_LOG`
    cp -rf $RESULTS_DIR/* .

    git add .
    git commit -m 'Publishing perf-test results for '"$TEST_SIMULATION"' run.'
    git push origin main

    git status

    echo "Simulation results published to git!"
  fi
fi


# Report the results to the aggregator.
if [ "x$TEST_REPORT_RESULTS" = "xtrue" ]
then
  mkdir -p /tmp/uploads
  echo "Uploading simulation log..."

  # Find and stage the simulation.log file into /tmp/uploads
  LOG_NAME=simulation-$UUID.log
  UPLOAD_FILE=/tmp/uploads/$LOG_NAME
  echo "---"
  find /apps/gatling/ | grep log
  echo "---"
  find /apps/gatling/results/ -name 'simulation.log' -exec cp {} $UPLOAD_FILE \;

  # upload the simulation file
  echo "------------------------"
  echo "Uploading the simulation file: $UPLOAD_FILE"
  echo ""
  cd /tmp/uploads
  ls -al
  zip $UPLOAD_FILE.zip $LOG_NAME
  ls -al
  UPLOAD_URL=http://$TEST_AGGREGATOR_HOST:$TEST_AGGREGATOR_PORT/api/aggregator/logs/$LOG_NAME.zip
  echo "Uploading to: $UPLOAD_URL"
  curl --raw -v -i -X POST -H "Content-Type: application/zip" $UPLOAD_URL --data-binary @$UPLOAD_FILE.zip
  echo "------------------------"

  # report the worker finish, this will trigger the processing of the uploaded simulation file
  echo "Reporting worker finished..."
  curl -X PUT http://$TEST_AGGREGATOR_HOST:$TEST_AGGREGATOR_PORT/api/aggregator/workers/$UUID/stop --fail

  echo "Simulation run complete and reported!"

fi
