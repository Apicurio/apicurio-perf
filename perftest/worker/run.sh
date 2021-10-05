#!/bin/sh

if [[ -z $TEST_SIMULATION ]] ; then
  export TEST_SIMULATION=End2EndSimulation
fi
if [[ -z $TEST_RAMP_TIME ]] ; then
  export TEST_RAMP_TIME=5
fi
if [[ -z $TEST_USERS ]] ; then
  export TEST_USERS=1
fi
if [[ -z $TEST_ITERATIONS ]] ; then
  export TEST_ITERATIONS=1
fi

# only required for some simulations, e2e simulation does not require this env var
if [[ -z $REGISTRY_URL ]] ; then
  export REGISTRY_URL=http://127.0.0.1:9090/apis/registry/v2
fi
if [[ -z $FLEET_MANAGER_URL ]] ; then
  export FLEET_MANAGER_URL=https://api.stage.openshift.com/api/serviceregistry_mgmt
fi
if [[ -z $TOKEN_URL ]] ; then
  export TOKEN_URL=https://identity.api.stage.openshift.com/auth/realms/rhoas/protocol/openid-connect/token
fi


# optional env var TEST_REPORT_RESULTS
if [[ -z $TEST_AGGREGATOR_HOST ]] ; then
  export TEST_AGGREGATOR_HOST=localhost
fi
if [[ -z $TEST_AGGREGATOR_PORT ]] ; then
  export TEST_AGGREGATOR_PORT=5080
fi

if [ "x$TEST_SIMULATION" = "xEnd2EndSimulation" ]
then

  if [[ -z $ADMIN_CLIENT_ID || \
      -z $ADMIN_CLIENT_SECRET || \
      -z $DEV_CLIENT_ID || \
      -z $DEV_CLIENT_SECRET || \
      -z $OFFLINE_TOKEN ]] ; then
    echo "Required env vars not provided. Exiting...".
    exit 1
  fi

fi

if [[ -z $OCM_URL ]] ; then
  export OCM_URL=staging
fi
if [[ -z $OFFLINE_TOKEN ]] ; then
  export OFFLINE_TOKEN=none
fi

# optional env var TEST_RESULTS_GITHUB_REPO
if [[ -z $TEST_RESULTS_GITHUB_USER ]] ; then
  export TEST_RESULTS_GITHUB_USER=apicurio-ci
fi
if [[ -z $TEST_RESULTS_GITHUB_EMAIL ]] ; then
  export TEST_RESULTS_GITHUB_EMAIL=apicurio.ci@gmail.com
fi
if [[ -z $TEST_RESULTS_GITHUB_PASS ]] ; then
  export TEST_RESULTS_GITHUB_PASS=none
fi


# Custom docker command (useful for windows where the command should be "winpty docker" instead of just "docker")
if [[ -z $DOCKER_CMD ]] ; then
  export DOCKER_CMD=docker
fi


$DOCKER_CMD run --network="host" -it \
    -e REGISTRY_URL=$REGISTRY_URL \
    -e OCM_URL=$OCM_URL \
    -e OFFLINE_TOKEN=$OFFLINE_TOKEN \
    -e TOKEN_URL=$TOKEN_URL \
    -e ADMIN_CLIENT_ID=$ADMIN_CLIENT_ID \
    -e ADMIN_CLIENT_SECRET=$ADMIN_CLIENT_SECRET \
    -e DEV_CLIENT_ID=$DEV_CLIENT_ID \
    -e DEV_CLIENT_SECRET=$DEV_CLIENT_SECRET \
    -e FLEET_MANAGER_URL=$FLEET_MANAGER_URL \
    -e TEST_USERS=$TEST_USERS \
    -e TEST_ITERATIONS=$TEST_ITERATIONS \
    -e TEST_RAMP_TIME=$TEST_RAMP_TIME \
    -e TEST_REPORT_RESULTS=$TEST_REPORT_RESULTS \
    -e TEST_AGGREGATOR_HOST=$TEST_AGGREGATOR_HOST \
    -e TEST_AGGREGATOR_PORT=$TEST_AGGREGATOR_PORT \
    -e TEST_SIMULATION=$TEST_SIMULATION \
    -e TEST_RESULTS_GITHUB_REPO=$TEST_RESULTS_GITHUB_REPO \
    -e TEST_RESULTS_GITHUB_USER=$TEST_RESULTS_GITHUB_USER \
    -e TEST_RESULTS_GITHUB_EMAIL=$TEST_RESULTS_GITHUB_EMAIL \
    -e TEST_RESULTS_GITHUB_PASS=$TEST_RESULTS_GITHUB_PASS \
    apicurio/apicurio-perftest-worker:latest
