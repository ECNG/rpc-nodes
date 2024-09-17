#!/bin/bash

#export AXELARD_VERSION=v1.0.0
#export TOFND_VERSION=v0.10.1
#export LIBWASM_VERSION=v1.3.1

#verify correct versions
echo $AXELARD_RELEASE $TOFND_RELEASE

# create a temp dir for binaries
cd $HOME
mkdir binaries && cd binaries


# Get axelard, tofnd binaries and rename
#wget https://github.com/axelarnetwork/axelar-core/releases/download/$AXELARD_VERSION/axelard-linux-amd64-$AXELARD_VERSION
wget -c https://axelar-releases.s3.us-east-2.amazonaws.com/axelard/$AXELARD_VERSION/axelard-linux-amd64-$AXELARD_VERSION

wget https://github.com/axelarnetwork/tofnd/releases/download/$TOFND_VERSION/tofnd-linux-amd64-$TOFND_VERSION
mv axelard-linux-amd64-$AXELARD_VERSION axelard
mv tofnd-linux-amd64-$TOFND_VERSION tofnd

# make binaries executable
chmod +x *

# move to usr bin
mv * /usr/bin/

cd /usr/lib
wget -c https://github.com/CosmWasm/wasmvm/releases/download/$LIBWASM_VERSION/libwasmvm.x86_64.so
ldconfig

# get out of binaries directory
cd $HOME

# check versions
axelard version
tofnd --help