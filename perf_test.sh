#!/bin/bash

make -C perftest/worker build

TEST_SIMULATION="${TEST_SIMULATION:-End2EndSimulation}"
TEST_USERS="${TEST_USERS:-30}"
TEST_ITERATIONS="${TEST_ITERATIONS:-600}"
TEST_RAMP_TIME="${TEST_RAMP_TIME:-45}"

./perftest/worker/run.sh