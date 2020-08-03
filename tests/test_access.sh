#!/bin/bash

#apply query at docker peer
RESULT=$(docker exec cli peer chaincode list --installed)
echo "$RESULT"
if [[ $RESULT == "Name: myc2"* ]]; then exit 1; fi