#!/bin/bash

#apply query at docker peer
RESULT=$(docker exec cli peer chaincode list --installed)
echo "$RESULT"
if [ "$RESULT" = "" ]; then exit 1; fi
