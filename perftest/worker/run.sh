#!/bin/sh

while [ "x$TEST_SIMULATION" = "x" ]
do
  export TEST_SIMULATION=End2EndSimulation
done
while [ "x$REGISTRY_URL" = "x" ]
do
  export REGISTRY_URL=http://127.0.0.1:9090/apis/registry/v2
done
while [ "xTEST_RAMP_TIME" = "x" ]
do
  export TEST_RAMP_TIME=5
done
while [ "xTEST_USERS" = "x" ]
do
  export TEST_USERS=1
done
while [ "xTEST_ITERATIONS" = "x" ]
do
  export TEST_ITERATIONS=1
done
while [ "xTEST_REPORT_RESULTS" = "x" ]
do
  export TEST_REPORT_RESULTS=true
done
while [ "xTEST_AGGREGATOR_HOST" = "x" ]
do
  export TEST_AGGREGATOR_HOST=localhost
done
while [ "xTEST_AGGREGATOR_PORT" = "x" ]
do
  export TEST_AGGREGATOR_PORT=5080
done
while [ "xTOKEN_URL" = "x" ]
do
  export TOKEN_URL=https://identity.api.stage.openshift.com/auth/realms/rhoas/protocol/openid-connect/token
done
while [ "xADMIN_CLIENT_ID" = "x" ]
do
  export ADMIN_CLIENT_ID=
done
while [ "xADMIN_CLIENT_SECRET" = "x" ]
do
  export ADMIN_CLIENT_SECRET=
done
while [ "xDEV_CLIENT_ID" = "x" ]
do
  export DEV_CLIENT_ID=
done
while [ "xDEV_CLIENT_SECRET" = "x" ]
do
  export DEV_CLIENT_SECRET=
done
while [ "xFLEET_MANAGER_URL" = "x" ]
do
  export FLEET_MANAGER_URL=https://api.stage.openshift.com/api/serviceregistry_mgmt
done
while [ "xOCM_URL" = "x" ]
do
  export OCM_URL=staging
done
while [ "xOFFLINE_TOKEN" = "x" ]
do
  export OFFLINE_TOKEN=none
done



# Custom docker command (useful for windows where the command should be "winpty docker" instead of just "docker")
while [ "xDOCKER_CMD" = "x" ]
do
  export DOCKER_CMD=docker
done


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
    apicurio/apicurio-perftest-worker:latest
