#!/bin/sh

RF_CONF="/etc/limemicro/trx-lms7002m/config-limeSDR/LimeSDR_Mini_above_1p8GHz.ini"
#ENB_CONF="/etc/openairinterface/enb.band1.tm1.50PRB.lmssdr.conf"
ENB_CONF="/etc/openairinterface/enb.conf"
LOG_DIR="/var/log/openairinterface"
LOG_FILE="${LOG_DIR}/enb.log"

echo "Launching eNB..."

mkdir -p $LOG_DIR
touch $LOG_FILE

tail -f $LOG_FILE &

lte-softmodem --T_stdout 0 --telnetsrv --nbiot-disable -O $ENB_CONF --rf-config-file $RF_CONF > $LOG_FILE 2>&1 &

/openairinterface5g/common/utils/T/tracer/enb -d /openairinterface5g/common/utils/T/T_messages.txt
