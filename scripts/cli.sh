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

#/opt/gopath/src/chaincodedev

echo "############################################################################################"
echo "#                                   INSTALLING CHAINCODE                                   #"
echo "############################################################################################"

# chaincode points to the chaincode directory in the UC4 repo
peer chaincode install -p chaincode -n ${CHAINCODE_NAME} -v 0 -l java

echo "############################################################################################"
echo "#                                   CHAINCODE INSTALLED                                    #"
echo "############################################################################################"




echo "############################################################################################"
echo "#                                   APPROVE CHAINCODE                                      #"
echo "############################################################################################"

export CHAINCODE_ID="$(peer lifecycle chaincode queryinstalled | sed -n '1!p' | sed 's/.*Package ID: \(.*\), Label.*/\1/')"


peer lifecycle chaincode approveformyorg \
  -o orderer:7050 \
  --channelID "$CHANNEL_NAME" \
  --name "$CHAINCODE_NAME" \
  --version 1.0 \
  --package-id "$CHAINCODE_ID" \
  --sequence 1 \
  --collections-config chaincode/collections_config.json

echo "############################################################################################"
echo "#                                   COMMIT CHAINCODE                                       #"
echo "############################################################################################"

peer lifecycle chaincode commit \
    -o orderer:7050 \
    --channelID "$CHANNEL_NAME" \
    --name "$CHAINCODE_NAME" \
    --version 1.0 \
    --sequence 1 \
    --peerAddresses peer:7051 \
    --collections-config chaincode/collections_config.json
    
    

echo "############################################################################################"
echo "#                                CHAINCODE  INSTALLED                                      #"
echo "#                                  READY FOR ACTION                                        #"
echo "############################################################################################"

sleep 600000
