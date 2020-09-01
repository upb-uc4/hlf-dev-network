#!/bin/bash

# configuration yaml folder
CONFIGFOLDERPATH="./"

# call tool with options
CHANNELFILE="myc.tx"
CHANNELID="myc"
PROFILE="OrgsChannel"

./configtxgen -configPath $CONFIGFOLDERPATH -channelID $CHANNELID -profile $PROFILE -outputCreateChannelTx $CHANNELFILE

echo "#############################################"
echo "#              created $CHANNELFILE         #"
echo "#############################################"


# call tool with options to create genesis block
ORIGINBLOCK="orderer.block"
CHANNELID="syschanel"
PROFILE="OrgsOrdererGenesis"
./configtxgen -configPath $CONFIGFOLDERPATH -channelID $CHANNELID -profile $PROFILE -outputBlock $ORIGINBLOCK

echo "#############################################"
echo "#              created $ORIGINBLOCK         #"
echo "#############################################"
