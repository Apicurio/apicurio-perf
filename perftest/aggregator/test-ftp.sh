#!/bin/bash

ftp -n localhost:5021 <<EOF
user anonymous
put simulation.log
EOF
