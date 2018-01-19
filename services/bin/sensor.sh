#!/bin/bash
# check free memory
val=$(free | awk -F' +' '/Mem/{print $3}')
/usr/local/bin/./containerpilot -config ${CONTAINERPILOT} -putmetric "free_memory=$val"

#jq -r 'to_entries[] | "\(.key)=\(.value)"' metrics.json | xargs -i /usr/local/bin/./containerpilot -config ${CONTAINERPILOT} -putmetric {}