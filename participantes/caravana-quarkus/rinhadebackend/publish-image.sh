#!/bin/bash

docker build -f src/main/docker/Dockerfile.jvm --no-cache --progress=plain -t caravanacloud/rinhadebackend:latest .
# Remember to docker login
docker push caravanacloud/rinhadebackend:latest
