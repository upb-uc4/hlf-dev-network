#!/bin/bash

#connect to docker
docker exec -it cli bash

RESULT=peer chaincode query -n mycc -c '{"Args":["getAllCourses"]}' -C myc
echo "$RESULT"
if [ "$RESULT" = "\[\]" ]; then exit 1; fi