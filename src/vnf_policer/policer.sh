#!/bin/bash

IN_IF="pol_vnf-eth0"
IFB="ifb0"

modprobe ifb 2>/dev/null || true
ip link add $IFB type ifb 2>/dev/null || true
ip link set $IFB up

tc qdisc del dev $IN_IF ingress 2>/dev/null || true
tc qdisc del dev $IFB root 2>/dev/null || true

echo "[policer] Setting ingress redirect $IN_IF -> $IFB"

tc qdisc add dev $IN_IF handle ffff: ingress

tc filter add dev $IN_IF parent ffff: protocol ip u32 \
  match u32 0 0 action mirred egress redirect dev $IFB

echo "[policer] Setting HTB on $IFB"

tc qdisc add dev $IFB root handle 1: htb default 40
tc class add dev $IFB parent 1: classid 1:1 htb rate 100mbit ceil 100mbit

tc class add dev $IFB parent 1:1 classid 1:10 htb rate 200kbit ceil 200kbit
tc class add dev $IFB parent 1:1 classid 1:20 htb rate 4mbit   ceil 4mbit
tc class add dev $IFB parent 1:1 classid 1:30 htb rate 1mbit   ceil 1mbit
tc class add dev $IFB parent 1:1 classid 1:40 htb rate 50mbit  ceil 50mbit

tc filter add dev $IFB protocol ip parent 1: prio 1 u32 \
  match ip tos 0xb8 0xfc flowid 1:10

tc filter add dev $IFB protocol ip parent 1: prio 2 u32 \
  match ip tos 0x88 0xfc flowid 1:20

tc filter add dev $IFB protocol ip parent 1: prio 3 u32 \
  match ip tos 0x28 0xfc flowid 1:30

echo "[policer] Ingress policing active"