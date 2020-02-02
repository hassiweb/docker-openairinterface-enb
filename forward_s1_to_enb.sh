#!/bin/sh

set -e

COMMAND="${@:-usage}"

if [ "`whoami`" != "root" ]; then
  echo "Require root privilege"
  exit 1
fi

usage () {
  echo "Usage: ./forward_s1_to_enb.sh {start|stop}"
}

start () {
  /sbin/iptables -I DOCKER-USER -p udp -s 0.0.0.0/0  -d 192.168.25.10 --dport 2152 -j ACCEPT
  /sbin/iptables -t nat -A DOCKER -p udp -m udp --dport 2152 -j DNAT --to-destination 192.168.25.10:2152
  /sbin/iptables -t nat -A POSTROUTING -p udp -m udp --dport 2152 -s 192.168.25.10 -d 192.168.25.10 -j MASQUERADE
  echo "Successfully add a forward rule for the S1 packet into the iptables."
}

stop () {
  /sbin/iptables -D DOCKER-USER -p udp -s 0.0.0.0/0  -d 192.168.25.10 --dport 2152 -j ACCEPT
  /sbin/iptables -t nat -D DOCKER -p udp -m udp --dport 2152 -j DNAT --to-destination 192.168.25.10:2152
  /sbin/iptables -t nat -D POSTROUTING -p udp -m udp --dport 2152 -s 192.168.25.10 -d 192.168.25.10 -j MASQUERADE
  echo "Successfully remove the forward rule for the S1 packet from the iptables."
}

$COMMAND
