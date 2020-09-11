#!/bin/bash

# configuration yaml folder
CONFIGFOLDERPATH="./"

# call tool with options
CHANNELFILE="../../myc.tx"
CHANNELID="myc"
PROFILE="SampleSingleMSPChannel"

pushd resources
./configtxgen -configPath $CONFIGFOLDERPATH -channelID $CHANNELID -profile $PROFILE -outputCreateChannelTx $CHANNELFILE
popd

echo "#############################################"
echo "#              created $CHANNELFILE         #"
echo "#############################################"


# call tool with options to create genesis block
ORIGINBLOCK="../../orderer.block"
CHANNELID="syschanel"
PROFILE="SampleDevModeSolo"

pushd resources
./configtxgen -configPath $CONFIGFOLDERPATH -channelID $CHANNELID -profile $PROFILE -outputBlock $ORIGINBLOCK
popd

echo "#############################################"
echo "#              created $ORIGINBLOCK         #"
echo "#############################################"
