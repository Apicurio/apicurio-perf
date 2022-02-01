#!/bin/bash

make -C perftest/worker build

TEST_SIMULATION="${TEST_SIMULATION:-ControlPlaneSimulation}"
TEST_USERS="${TEST_USERS:-50}"
TEST_ITERATIONS="${TEST_ITERATIONS:-300}"
TEST_RAMP_TIME="${TEST_RAMP_TIME:-60}"

./perftest/worker/run.sh