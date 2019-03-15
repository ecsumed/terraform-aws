#! /usr/bin/python

# Usage:
# ./data-sender.py 5 2 10 4

import sys
from time import time
from random import randint
import socket

hosts = sys.argv[1:][0]
metrics = sys.argv[1:][1]
max_val = sys.argv[1:][2]
batch = sys.argv[1:][3]

host = "127.0.0.1"
port = 2003

def netcat(host, port, content):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    s.connect(("127.0.0.1", 2003))
    s.sendall(content)
    s.shutdown(socket.SHUT_WR)
    s.close()

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
            netcat(host, port, payload)
            current_batch = 0
            payload = ""

if payload != "":
    netcat(host, port, payload)

