#!/bin/bash

#ssh -p 5022 -i id_rsa simuser@localhost
sshpass -p "simpass" scp -P 5022 simuser@localhost:/home/simuser/simulation.log simulation.log
