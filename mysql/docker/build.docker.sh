#!/usr/bin/env bash
docker build -t masterone:latest .

#docker run -itd --net=host --privileged=true --name masterone -v /tmp:/tmp masterone:latest

#docker rm -f $(docker ps -a -q)

#docker rmi masterone:latest

#docker exec -it masterone /bin/bash