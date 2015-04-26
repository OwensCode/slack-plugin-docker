#!/bin/sh

RUNNING=`docker ps --filter 'name=jenkins' | wc -l`

if [ ${RUNNING} -gt 1 ]; then
    echo "Container jenkins is already running"
else
    RUNNING=`docker ps -a --filter 'name=jenkins' | wc -l`

    if [ ${RUNNING} -gt 1 ]; then
        echo "Container jenkins already exists. Restarting ..."
        docker restart jenkins
    else
        echo "Starting docker container jenkins"
        docker run -d --name jenkins -p 8080:8080 jenkins
    fi
fi

BOOT2DOCKER=0
which boot2docker >/dev/null 2>&1
if [ $? -eq 0 ]; then
    BOOT2DOCKER=1
fi

HOST_IP='localhost'
if [ $BOOT2DOCKER -eq 1 ]; then
    HOST_IP=`boot2docker ip`
fi

echo "Jenkins should be available at http://${HOST_IP}:8080/"
