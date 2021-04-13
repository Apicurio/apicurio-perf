#!/bin/bash

sshpass -p "simpass" scp -o "StrictHostKeyChecking no" -P 5022 simuser@localhost:/home/simuser/simulation.log simulation.log
