#!/bin/bash

make -C perftest/worker build

export TEST_SIMULATION=ControlPlaneSimulation
export TEST_USERS=50
export TEST_ITERATIONS=300
export TEST_RAMP_TIME=60

./perftest/worker/run.sh