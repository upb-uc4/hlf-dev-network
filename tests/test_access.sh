#!/bin/bash

#apply query at docker peer
RESULT=$(docker exec cli peer chaincode list --installed)
echo "$RESULT"
if [[ $RESULT == "Get installed chaincodes on peer:\nName: mycc"* ]]; then exit 0; fi
exit 1