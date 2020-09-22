# Development-Network

![Hyperledger Dev Network Test Pipeline](https://github.com/upb-uc4/hlf-dev-network/workflows/Hyperledger%20Dev%20Network%20Test%20Pipeline/badge.svg)

## Prerequisites
* docker-compose
* docker-IO
* access to a linux machine

### Windows Troubleshooting:
* make sure your OS is up-to-date (e.g. build ~19041 or later; see Windows 10 Update Assistent etc.)
* make sure your docker installation is up-to-date (e.g. version ~19.0.8 or later)
* make sure your docker-compose installation is up-to-date (e.g. version ~1.25 or later)
* if you get the error `shadowJar x...` during chaincode compilation, try `$ git config --global core.autocrlf false` and re-cloning the repository
* if you get the startup orderer error: make sure "WSL2" (Windows Subsystem for Linux) is installed

This seems to fix the issues for under Windows for us. Please let us know if you still run into issues.

### Generating the channel-description and the genesis-block
The network will read the genesis block ```./orderer.block``` and the channel description ```./myc.tx``` which have to be generated before starting the network.
They are determined by the ```./scripts/resources/configtx.yaml```.
To create these files you have to execute the script ```./scripts/createChannelTx.sh```, which needs to be done on a linux system since it executes the linux-binary ```./scripts/resources/configtx```.

## Starting the Network
To start the development network simply clone the repository, execute

```bash
$ ./startNetwork.sh
```

and wait for the network to start. Do not wait for the console ouput to stop! Once the network outputs

```bash
############################################################################################
#                                   CHAINCODE INITIALIZED                                  #
#                                     READY FOR ACTION                                     #
############################################################################################
```
it has succesfully started. This may take a few minutes.

Alternatively, you can start the network by executing

```bash
$ docker-compose -f docker-compose-simple.yaml up
```
Note that in this case you have to remove the containers manually before restarting the network.

Starting the network starts an orderer (```orderer```), a peer (```peer```), a chaincode container (```chaincode```), a couchdb container (```couchdb```), and a command-line-interface container (```cli```).

*  ```chaincode``` is the container compiling and running the chaincode for the peer. For that, a ```build.gradle``` is required in the ```chaincode``` java-project.
* ```couchdb``` is used internally to store the ledger state. You probably do not have to worry about this.
* ```cli``` provides fabric binaries that can be utilized to do all sorts of stuff to the network manually (e.g. query chaincode, add channels, register/enroll users etc.)

## Query/Invoke Manually

Once the network is up, chaincode can be manually queried/invoked by executing

```bash
$ docker exec -it cli bash
```

which opens a shell inside the ```cli``` container, from which fabrics binaries can be used as usual, e.g.

```bash
$ peer chaincode query -n mycc -c '{"Args":["getAllCourses"]}' -C myc
```

calls the ```queryAll``` transaction inside the ```mycc``` chaincode on channel ```myc```,

```bash
$ peer chaincode invoke -n mycc -c '{"Args":["transactionName","arg1","arg2","arg3"]}' -C myc
```

calls the ```transactionName``` transactioninside the ```mycc``` chaincode on channel ```myc``` with arguments ```arg1```,```arg2```,```arg3```.
You can also use the ```--transient``` flag to pass data via the transient data field (see example below).
The chaincode does currently not need to be initialized/installed, as the development-network does that during it's setup (./startNetwork.sh) for you.

**WARNING:** If you want to pass json as a string argument to a transaction, you must put a ```\"``` instead of every ```"``` in the inner json, e.g.

```bash
$ peer chaincode invoke -n mycc -c '{"Args":["transactionName","{\"attribute\": \"value\"}"]}' -C myc
```

Example chaincode invocation:

```bash
$ peer chaincode invoke -n mycc -c '{"Args":["addCourse","{ \"courseId\": \"course1\",\"courseName\": \"courseName1\",\"courseType\": \"Lecture\",\"startDate\": \"2020-06-29\",\"endDate\": \"2020-06-29\",\"ects\": 3,\"lecturerId\": \"lecturer1\",\"maxParticipants\": 100,\"currentParticipants\": 0,\"courseLanguage\": \"English\",\"courseDescription\": \"some lecture\" }"]}' -C myc
```

Example chaincode invocation utilizing transient data:

```bash
$ export VALUE=$(echo -n "{\"matriculationId\":\"0000001\",\"firstName\":\"firstName1\",\"lastName\":\"lastName1\",\"birthDate\":\"1900-07-21\",\"matriculationStatus\":[{\"fieldOfStudy\":\"Computer Science\",\"semesters\":[\"SS2020\"]}]}" | base64 | tr -d \\n)
$ peer chaincode invoke -n mycc -c '{"Args":["addMatriculationData"]}' --transient "{\"0\":\"$VALUE\"}" -C myc
```


## Chaincode and Channel Name

```myc``` and ```mycc``` are the names given to the channel and the chaincode respectively by default.
The channel name can be adjusted by setting the variable ```CHAINCODE_NAME``` in 

```
./scripts/variables.sh
```

The channel name can currently not be changed, unless you are familiar with hyperledger's configtx tool etc.

## Ports
* the peer is reachable under ```localhost:7051```
* the orderer is reachable under ```localhost:7050```

When listing URLs in connection profiles, make sure to add the right protocol (e.g. ```grpc://localhost:7051```).
The development network does not support grpc over TLS.

**WARNING:** Once the production network is up, ```grpcs``` should be used!
