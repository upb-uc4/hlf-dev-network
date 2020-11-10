#!/bin/bash

source /opt/gopath/src/scripts/variables.sh

echo "Start sleep"
sleep 15s
echo "Finish sleep"

pushd /opt/gopath/src/chaincode

# wait for 'cli' to commit chaincode
echo "" | nc -l -p 8080 > tmp.txt
cat tmp.txt
export CORE_CHAINCODE_ID_NAME=$(cat tmp.txt)
echo "Continuing..."
sleep 10s

echo "Received: $CORE_CHAINCODE_ID_NAME"

echo "############################################################################################"
echo "#                                   STARTING CHAINCODE                                     #"
echo "############################################################################################"

export CORE_PEER_TLS_ENABLED=false 
./gradlew run

popd
