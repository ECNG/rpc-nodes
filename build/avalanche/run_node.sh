#!/bin/bash

echo "Start Script"

if [ -f "/root/.avalanchego/configs/node.json" ];
then
  echo " START NODE"
  /opt/node/avalanchego/avalanchego --db-type=pebbledb --http-host=0.0.0.0 --http-allowed-origins='*' --http-allowed-hosts='*' &

  wait -n

  exit $?

else
  echo "### Initialization node ###"
  foundIP="$(wget -qO- eth0.me)"

  mkdir -p /root/.avalanchego/configs
  cd /root/.avalanchego/configs

  echo "{" >>node.json
  echo "  \"http-host\": \"\",">>node.json
  echo "  \"api-admin-enabled\": true,">>node.json
  echo "  \"index-enabled\": true,">>node.json
  echo "  \"public-ip\": \"$foundIP\"">>node.json
  echo "}" >>node.json

  mkdir -p /root/.avalanchego/configs/chains/C/
  cd /root/.avalanchego/configs/chains/C/

  echo "{" >>config.json
    echo "  \"state-sync-enabled\": true,">>config.json
    echo "  \"pruning-enabled\": false">>config.json
  echo "}" >>config.json

fi