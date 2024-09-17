#!/bin/bash

PRIV_KEY_FILE=/$HOME/.axelar/config/priv_validator_key.json

init_node() {
  command -v jq > /dev/null 2>&1 || { echo >&2 "jq not installed. More info: https://stedolan.github.io/jq/download/"; exit 1; }

      expect -c "
        #!/usr/bin/expect -f
        set timeout -1

        spawn axelard keys add broadcaster
        exp_internal 0
        expect \"Enter keyring passphrase:\"
        send   \"$KEYRING_PASSWORD\n\"
        expect \"Re-enter keyring passphrase:\"
        send   \"$KEYRING_PASSWORD\n\"
        expect eof
    "

      expect -c "
        #!/usr/bin/expect -f
        set timeout -1

        spawn axelard keys add validator
        exp_internal 0
        expect \"Enter keyring passphrase:\"
        send   \"$KEYRING_PASSWORD\n\"
        expect \"Re-enter keyring passphrase:\"
        send   \"$KEYRING_PASSWORD\n\"
        expect eof
    "

      expect -c "
        #!/usr/bin/expect -f
        set timeout -1

        spawn tofnd -m create
        exp_internal 0
        expect \"Please type your tofnd password:\"
        send   \"$KEYRING_PASSWORD\n\"
        expect eof
    "

  echo export CHAIN_ID=$CHAINID >> $HOME/.profile
  echo export MONIKER=$MONIKER >> $HOME/.profile

  VALIDATOR_OPERATOR_ADDRESS=`echo $KEYRING_PASSWORD | axelard keys show validator --bech val --output json | jq -r .address`
  BROADCASTER_ADDRESS=`echo $KEYRING_PASSWORD | axelard keys show broadcaster --output json | jq -r .address`

  echo export VALIDATOR_OPERATOR_ADDRESS=$VALIDATOR_OPERATOR_ADDRESS >> $HOME/.profile
  echo export BROADCASTER_ADDRESS=$BROADCASTER_ADDRESS >> $HOME/.profile
  echo export KEYRING_PASSWORD=$KEYRING_PASSWORD >> $HOME/.profile
}

start_node() {
   echo "START NODE"
   /usr/bin/axelard start &
   echo $KEYRING_PASSWORD | tofnd -m existing -d $HOME/.tofnd > /var/log/axelard/tofnd.log &
   /opt/scripts/vald-start.sh &
   #echo $KEYRING_PASSWORD | /usr/bin/axelard vald-start --validator-addr $VALIDATOR_OPERATOR_ADDRESS --log_level debug --chain-id $CHAIN_ID --from broadcaster > /var/log/axelard/validator.log &

  wait -n

  # Exit with status of process that exited first
  exit $?

}

set_variable() {
  echo $KEYRING_PASSWORD
  source $HOME/.profile

}

init_node_2() {
axelard init $MONIKER --chain-id $CHAIN_ID
wget https://raw.githubusercontent.com/axelarnetwork/axelarate-community/main/configuration/config.toml -O $HOME/.axelar/config/config.toml
wget https://raw.githubusercontent.com/axelarnetwork/axelarate-community/main/configuration/app.toml -O $HOME/.axelar/config/app.toml

if [ "$NETWORK" = "mainnet" ]; then
        wget https://axelar-mainnet.s3.us-east-2.amazonaws.com/genesis.json -O $HOME/.axelar/config/genesis.json
elif [ "$NETWORK" = "testnet" ]; then
        wget https://raw.githubusercontent.com/axelarnetwork/axelarate-community/main/resources/testnet/genesis.json -O $HOME/.axelar/config/genesis.json
fi

wget https://raw.githubusercontent.com/axelarnetwork/axelarate-community/main/resources/$NETWORK/seeds.toml -O $HOME/.axelar/config/seeds.toml

# set external ip to your config.json file
sed -i.bak 's/external_address = ""/external_address = "'"$(curl -4 ifconfig.co)"':26656"/g' $HOME/.axelar/config/config.toml
}

sync_snap() {
   axelard tendermint unsafe-reset-all
   URL=`curl -L https://quicksync.io/axelar.json | jq -r '.[] |select(.file=="'$MONIKER'")|.url'`
   echo $URL
   cd $HOME/.axelar/
   wget -O - $URL | lz4 -d | tar -xvf -
   cd $HOME
}

if [[ $LOGLEVEL && $LOGLEVEL == "debug" ]]
then
  set -x
fi

if [ -f "$PRIV_KEY_FILE" ];
then
  echo "### Run node ###"
  set_variable
  start_node
else
  echo "### Initialization node ###"
  init_node
  set_variable
  init_node_2
  sync_snap
  start_node
fi