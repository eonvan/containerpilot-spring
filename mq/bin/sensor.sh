#!/bin/bash
# check free memory
val=$(free | awk -F' +' '/Mem/{print $3}')
/usr/local/bin/./containerpilot -putmetric "free_memory=$val"