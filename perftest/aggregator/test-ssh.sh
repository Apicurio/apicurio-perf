#!/bin/bash

# sshpass -p "simpass" scp -P 5022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null simuser@localhost:/home/simuser/logs/simulation.log simulation.log

# sshpass -p "simpass" scp -P 5022 simuser@localhost:/home/simuser/simulation.log simulation.log


# curl --insecure --user simuser:simpass -T simulation.log sftp://home/simuser/logs/simulation.log
