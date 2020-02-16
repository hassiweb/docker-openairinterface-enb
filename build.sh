#!/bin/sh

set -e

OAI_VER=v1.0.3
#OAI_VER=v1.2.1

usage() {
  echo "Usage: sh build.sh {enb|split}"
}

main() {
  if [ $1 = "enb" ]; then
    docker build -f Dockerfile.base -t hassiweb/oai-base:$OAI_VER . --build-arg OAI_VER=$OAI_VER
    docker build -f Dockerfile.enb.lmssdr -t hassiweb/oaienb-lms:$OAI_VER . --build-arg OAI_VER=$OAI_VER
  elif [ $1 = "split" ]; then
    docker build -f Dockerfile.base -t hassiweb/oai-base:$OAI_VER . --build-arg OAI_VER=$OAI_VER
    docker build -f Dockerfile.rcc -t hassiweb/oaircc:$OAI_VER . --build-arg OAI_VER=$OAI_VER
    docker build -f Dockerfile.rru.lmssdr -t hassiweb/oairru-lms:$OAI_VER . --build-arg OAI_VER=$OAI_VER
#  elif [ $1 = "ue" -a $2 = "nfapi" ]; then
#    docker build -f Dockerfile.base -t hassiweb/oai-base:$OAI_VER . --build-arg OAI_VER=$OAI_VER
#    docker build -f Dockerfile.ue.nfapi -t hassiweb/oaiue-nfapi:$OAI_VER . --build-arg OAI_VER=$OAI_VER
  else
    usage
  fi
}

main "$@"
