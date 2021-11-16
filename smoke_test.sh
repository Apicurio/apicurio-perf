#!/bin/bash

make -C perftest/worker build

export TEST_SIMULATION=End2EndSimulation
export TEST_USERS=3
export TEST_ITERATIONS=50
export TEST_RAMP_TIME=30

./perftest/worker/run.sh