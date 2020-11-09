#!/bin/bash

sleep 10s 

source /opt/gopath/src/chaincodedev/scripts/variables.sh

echo "############################################################################################"
echo "#                                   SETTING UP CHANNEL                                     #"
echo "############################################################################################"

set -e
# create channel from .tx - file
peer channel create -c myc -f myc.tx -o orderer:7050

echo "############################################################################################"
echo "#                                   JOINING    CHANNEL                                     #"
echo "############################################################################################"

# join channel
peer channel join -b myc.block

echo "############################################################################################"
echo "#                                   CHANNEL SETUP DONE                                     #"
echo "############################################################################################"

# wait for 'chaincode' to compile chaincode
echo "" | nc -l -p 8080
echo "Continuing..."
# wait for 'chaincode' to start chaincode
sleep 10s



echo "############################################################################################"
echo "#                                     PACKAGE CHAINCODE                                    #"
echo "############################################################################################"

peer lifecycle chaincode package mycc.tar.gz \
    --path UC4-chaincode/build/install/UC4-chaincode \
    --lang java \
    --label $CHAINCODE_NAME

echo "############################################################################################"
echo "#                                   INSTALLING CHAINCODE                                   #"
echo "############################################################################################"

# chaincode points to the chaincode directory in the UC4 repo
peer lifecycle chaincode install mycc.tar.gz
export CHAINCODE_ID="$(peer lifecycle chaincode queryinstalled | sed -n '1!p' | sed 's/.*Package ID: \(.*\), Label.*/\1/')"

echo "############################################################################################"
echo "#                          CHAINCODE INSTALLED $CHAINCODE_ID                               #"
echo "############################################################################################"

# notify 'chaincode' that chaincode is compiled
echo "$CHAINCODE_ID" | nc chaincode 8080

# wait for 'chaincode' to start chaincode
sleep 30s


echo "############################################################################################"
echo "#                           APPROVE CHAINCODE $CHAINCODE_ID                                #"
echo "############################################################################################"

peer lifecycle chaincode approveformyorg \
  --orderer orderer:7050 \
  --channelID "$CHANNEL_NAME" \
  --name "$CHAINCODE_NAME" \
  --version 1.0 \
  --package-id "$CHAINCODE_ID" \
  --sequence 1 \
  --collections-config UC4-chaincode/collections_config_dev.json
  
echo "############################################################################################"
echo "#                   2        APPROVE CHAINCODE $CHAINCODE_ID                               #"
echo "############################################################################################"
  
# check approved
peer lifecycle chaincode checkcommitreadiness \
  --channelID "$CHANNEL_NAME" \
  --name "$CHAINCODE_NAME" \
  --version 1.0 \
  --sequence 1 \
  --output json \
  --collections-config UC4-chaincode/collections_config_dev.json

echo "############################################################################################"
echo "#                            COMMIT CHAINCODE $CHAINCODE_ID                                #"
echo "############################################################################################"

peer lifecycle chaincode commit \
    --orderer orderer:7050 \
    --channelID "$CHANNEL_NAME" \
    --name "$CHAINCODE_NAME" \
    --version 1.0 \
    --sequence 1 \
    --peerAddresses peer:7051 \
    --collections-config UC4-chaincode/collections_config_dev.json

echo "############################################################################################"
echo "#                               Check COMMITTED CHAINCODE                                  #"
echo "############################################################################################"
    
peer lifecycle chaincode querycommitted \
  --channelID "$CHANNEL_NAME" \
  --name "$CHAINCODE_NAME" \
  --output json

echo "############################################################################################"
echo "#                                CHAINCODE  INSTALLED                                      #"
echo "#                                  READY FOR ACTION                                        #"
echo "############################################################################################"

sleep 600000
