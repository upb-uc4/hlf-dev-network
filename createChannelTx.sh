#!/bin/bash

# adjust this
export FABRIC_CFG_PATH = ~/Documents/git/hlf-dev-network/configtx.yaml

./configtxgen -profile OrgsChannel -outputCreateChannelTx myc2.tx -channelID myc -configPath ./configtx.yaml

echo "#############################################"
echo "#             created myc2.tx               #"
echo "#############################################"
