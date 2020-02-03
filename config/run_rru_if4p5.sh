#!/bin/sh

RF_CONF="/etc/limemicro/trx-lms7002m/config-limeSDR/LimeSDR_Mini_above_1p8GHz.ini"
ENB_CONF="/etc/openairinterface/rru.band1.if4p5.lmssdr.conf"
LOG_DIR="/var/log/openairinterface"
LOG_FILE="${LOG_DIR}/rru.log"

echo "Launching RRU with IF4.5 ..."

mkdir -p $LOG_DIR
touch $LOG_FILE

tail -f $LOG_FILE &

lte-softmodem -O $ENB_CONF --rf-config-file $RF_CONF > $LOG_FILE 2>&1
