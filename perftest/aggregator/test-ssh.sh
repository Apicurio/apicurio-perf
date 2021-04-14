#!/bin/bash

# sshpass -v -p "simpass" scp -P 5022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null simulation.log simuser@localhost:/home/simuser/logs/simulation.log

# sshpass -p "simpass" scp -P 5022 simuser@localhost:/home/simuser/simulation.log simulation.log


# curl --insecure --user simuser:simpass -T simulation.log sftp://localhost:5052/home/simuser/logs/simulation.log


#export LFTP_PASSWORD="simpass"
#lftp -u simuser,simpass -p 5052 localhost -e "cd logs; put simulation.log; bye"
#sshpass -p "simpass" sftp -P 5022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null simuser@localhost:/home/simuser/logs/simulation.log simulation.log


# sshpass -v -p "simpass" ssh -p 5022 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null simuser@localhost /process.sh
