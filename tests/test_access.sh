#!/bin/bash

#apply query at docker peer
RESULT=$(docker exec -it cli peer chaincode query -n mycc -c '{"Args":["getAllCourses"]}' -C myc)
echo "$RESULT"
if [ "$RESULT" = "\[\]" ]; then exit 1; fi
