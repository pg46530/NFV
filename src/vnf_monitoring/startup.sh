#!/bin/bash

while ! ip link show mon_vnf-eth0 >/dev/null 2>&1; do sleep 0.1; done
while ! ip link show mon_vnf-eth1 >/dev/null 2>&1; do sleep 0.1; done

brctl addbr br2
brctl addif br2 mon_vnf-eth0
brctl addif br2 mon_vnf-eth1

ip link set mon_vnf-eth0 up
ip link set mon_vnf-eth1 up
ip link set br2 up

brctl stp br2 off
brctl setfd br2 0

echo ">>> Monitoring VNF bridge br2 ready"

/usr/bin/prometheus-node-exporter &
echo ">>> node_exporter running on port 9100"

tail -f /dev/null
