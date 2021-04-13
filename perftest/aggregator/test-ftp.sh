#!/bin/bash

ftp -dvn <<EOF
open localhost 5021
user anonymous anonymous
put simulation.log
EOF
