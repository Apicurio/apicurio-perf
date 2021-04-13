#!/bin/bash

ftp -n localhost 5021 <<EOF
user anonymous anonymous
put simulation.log
EOF
