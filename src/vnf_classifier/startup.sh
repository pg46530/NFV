#!/bin/bash

while ! ip link show dscp_vnf-eth0 >/dev/null 2>&1; do sleep 0.1; done
while ! ip link show dscp_vnf-eth1 >/dev/null 2>&1; do sleep 0.1; done

brctl addbr br0
brctl addif br0 dscp_vnf-eth0
brctl addif br0 dscp_vnf-eth1

ip link set dscp_vnf-eth0 up
ip link set dscp_vnf-eth1 up
ip link set br0 up

echo ">>> Bridge was successfully created"

# VOIP (UDP 5060) - DSCP 46
iptables -t mangle -A PREROUTING -p udp --dport 5060 -j DSCP --set-dscp 46

# Video (UDP 5004) - DSCP 34
iptables -t mangle -A PREROUTING -p udp --dport 5004 -j DSCP --set-dscp 34

# Bulk (TCP 5001) - DSCP 10
iptables -t mangle -A PREROUTING -p tcp --dport 5001 -j DSCP --set-dscp 10

tail -f /dev/null