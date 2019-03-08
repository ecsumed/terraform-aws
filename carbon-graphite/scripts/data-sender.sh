#! /bin/bash

# Usage:
# ./data-sender.sh 3 3 10 | nc -q0 127.0.0.1 2003

HOSTS=$1
METRICS=$2
MAX_VALUE=$3

time=$(date +%s)

for host in $(seq 1 $HOSTS)
do
    for metric in $(seq 1 $METRICS)
    do
        echo "cg.host-${host}.metric-${metric} $((RANDOM%100)) $time"
    done
done

