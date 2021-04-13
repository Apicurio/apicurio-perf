#!/bin/bash

ftp -n <<EOF
connect localhost 5021
user anonymous anonymous
put simulation.log
EOF
