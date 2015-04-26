#!/bin/sh

docker run --rm -t -i \
    -v $PWD/../slack-plugin:/slack-plugin \
    -v $PWD/m2repo:/var/m2repo \
    slack-plugin-build \
    mvn clean package

