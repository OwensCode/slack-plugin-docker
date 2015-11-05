#!/bin/sh

JENKINS_VERSION=1.625.1

RUNNING=$(docker ps --filter 'name=jenkins' | wc -l)

if [ "${RUNNING}" -gt 1 ]; then
    echo "Container jenkins is already running"
else
    RUNNING=$(docker ps -a --filter 'name=jenkins' | wc -l)

    if [ "${RUNNING}" -gt 1 ]; then
        echo "Container jenkins already exists. Restarting ..."
        docker restart jenkins
    else
        echo "Starting docker container jenkins"
        docker run -d --name jenkins -p 8080:8080 jenkins:${JENKINS_VERSION}
    fi
fi

BOOT2DOCKER=0
DOCKER_MACHINE=0

which boot2docker >/dev/null 2>&1
if [ $? -eq 0 ]; then
    BOOT2DOCKER=1
else
    which docker-machine >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        DOCKER_MACHINE=1
    fi
fi

HOST_IP='localhost'

if [ $BOOT2DOCKER -eq 1 ]; then
    HOST_IP=$(boot2docker ip)
elif [ $DOCKER_MACHINE -eq 1 ]; then
    HOST_IP=$(docker-machine ip "$DOCKER_MACHINE_NAME")
fi

echo "Jenkins should be available at http://${HOST_IP}:8080/"
