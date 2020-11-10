#!/bin/bash

# read parameter
if [ -z "$1" ]
then
  # BRANCH_TAG default branch = develop
  echo "Installing latest chaincode from develop."
  echo "Use './installChaincode.sh [release]' to specify another version (e.g. v0.12.2) ."
  export CHAINCODE_VERSION="v0.12.2"
else
  # BRANCH_TAG read from parameter
  export CHAINCODE_VERSION=$1
fi
echo "######################################################"
echo "Download chaincode with version: $CHAINCODE_VERSION"
echo "######################################################"

# dowload chaincode
mkdir -p chaincode/assets
mkdir -p chaincode/UC4-chaincode
wget -c https://github.com/upb-uc4/hlf-chaincode/releases/download/"$CHAINCODE_VERSION"/UC4-chaincode.tar.gz -O - | tar -xz -C "./chaincode/UC4-chaincode"
echo "######################################################"
echo "Download assets"
echo "######################################################"
wget -c https://github.com/upb-uc4/hlf-chaincode/releases/download/"$CHAINCODE_VERSION"/collections_config_dev.json -O "./chaincode/assets/collections_config_dev.json"

echo "#############################################"
echo "chaincode ready"
echo "#############################################"
