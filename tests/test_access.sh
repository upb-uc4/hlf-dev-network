#!/bin/bash

#apply query at docker peer
RESULT=$(docker exec cli peer chaincode list --installed)
echo "$RESULT"
if [[ $RESULT =~ "Name: mycc" ]]; then exit 0; fi
echo "#######################"
echo "# chaincode retrieved #"
echo "#   the wrong lists   #"
echo "#   \"Name: mycc\"    #"
echo "#   was not found     #"
echo "#######################"
exit 1