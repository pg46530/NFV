#!/bin/bash

while ! ip link show pol_vnf-eth0 >/dev/null 2>&1; do sleep 0.05; done
while ! ip link show pol_vnf-eth1 >/dev/null 2>&1; do sleep 0.05; done

brctl addbr br1
brctl addif br1 pol_vnf-eth0
brctl addif br1 pol_vnf-eth1

ip link set pol_vnf-eth0 up
ip link set pol_vnf-eth1 up
ip link set br1 up

echo ">>> policer: bridge br1 created and interfaces up"
ip a

bash /policer.sh

tail -f /dev/null