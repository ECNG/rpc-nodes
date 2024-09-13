#!/bin/bash

echo "Start Script"

if [ -f "/root/bsc_config/genesis.json" ];
then
  echo " START NODE"
  /opt/bsc/geth  --config /root/bsc_config/config.toml --syncmode=full --history.transactions=0 --db.engine pebble --tries-verify-mode none  --pruneancient=true --diffblock=5000 --cache 8000 --rpc.allow-unprotected-txs --datadir /data/node --maxpeers 200 --http --http.addr "0.0.0.0" --http.port "6545" --http.corsdomain "*" --http.vhosts "*" --ws --ws.addr "0.0.0.0" --ws.port "6546" --ws.origins "*" --metrics --metrics.addr "0.0.0.0" --metrics.port 6060  &

  wait -n

  exit $?

else
  echo "### Initialization node ###"

  #mkdir /root/bsc_config/node && cd /root/bsc_config/node/
  #curl -o - https://download.bsc-snapshot.workers.dev/geth-20221226.tar.lz4 | tar -I lz4 -xvf -

  #init genesis
  mkdir /root/bsc_config && cd /root/bsc_config && wget -c https://github.com/bnb-chain/bsc/releases/download/$VERSION/mainnet.zip && unzip mainnet.zip && mv ./* /root/bsc_config/ && rm -rf mainnet.zip
  /opt/bsc/geth --datadir node init genesis.json

fi