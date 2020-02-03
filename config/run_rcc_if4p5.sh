#!/bin/sh

ENB_CONF="/etc/openairinterface/rcc.band1.tm1.if4p5.conf"
LOG_DIR="/var/log/openairinterface"
LOG_FILE="${LOG_DIR}/rcc.log"

echo "Launching RCC with IF4.5 ..."

mkdir -p $LOG_DIR
touch $LOG_FILE

tail -f $LOG_FILE &

lte-softmodem -O $ENB_CONF > $LOG_FILE 2>&1
