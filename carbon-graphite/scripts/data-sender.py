#! /usr/bin/python

# Usage:
# ./data-sender.py 5 2 10 localhost 2003 4

import sys
from time import time
from random import randint
import subprocess

hosts = sys.argv[1:][0]
metrics = sys.argv[1:][1]
max_val = sys.argv[1:][2]
host = sys.argv[1:][3]
port = sys.argv[1:][4]
batch = sys.argv[1:][5]

def nc_send(output, host, port):
    p1 = subprocess.Popen(["echo", '"{}"'.format(output)], stdout=subprocess.PIPE)
    p2 = subprocess.Popen(["nc", "-q0", str(host), str(port)], stdin=p1.stdout)
    p1.stdout.close()
    p2.communicate()

epoch = time()
current_batch = 0
payload = ''
for host in xrange(1, int(hosts) + 1):
    for metric in xrange(1, int(metrics) + 1):
        payload += "cg.host-{}.metric-{} {} {}\n".format(
            host,
            metric,
            randint(0, int(max_val)),
            epoch,
        )
        current_batch += 1

        if current_batch >= int(batch):
            nc_send(payload, host, port)
            current_batch = 0
            payload = ""

if payload != "":
    nc_send(payload, host, port)
