#!/bin/sh

docker stop jenkins
echo "Stopped container jenkins"
docker rm jenkins
echo "Removed container jenkins"

