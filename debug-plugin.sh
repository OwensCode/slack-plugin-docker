#!/bin/sh

docker run --rm -t -i \
    -v "$PWD"/../slack-plugin:/slack-plugin \
    -v "$PWD"/../slack-plugin-docker/m2repo:/var/m2repo \
    -p 8080:8080 -p 8000:8000 \
    -e MAVEN_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,address=8000,suspend=n" \
    slack-plugin-build \
    mvn hpi:run

