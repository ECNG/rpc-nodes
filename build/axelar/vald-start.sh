#!/bin/bash

until vald-start; do
    echo "Start VALD Service" >> /var/log/axelard/validator.log
    echo $KEYRING_PASSWORD | /usr/bin/axelard vald-start --validator-addr $VALIDATOR_OPERATOR_ADDRESS --log_level debug --chain-id $CHAINID --from broadcaster &>> /var/log/axelard/validator.log
    echo "Crushed VALD Service, wait 5 sec" >> /var/log/axelard/validator.log
    sleep 5
done
