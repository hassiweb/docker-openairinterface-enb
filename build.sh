#!/bin/sh

set -e

NODE="${@:-usage}"
HW=$2

usage () {
  echo "Usage:"
}

enb () {
  docker build -f Dockerfile.base -t hassiweb/oai-base:v1.0.3 .
  if [ $HW = "lmssdr" ]; then
    docker build -f Dockerfile.enb.lmssdr -t hassiweb/oai-enb-lms:v1.0.3 .
  fi
}

$NODE
