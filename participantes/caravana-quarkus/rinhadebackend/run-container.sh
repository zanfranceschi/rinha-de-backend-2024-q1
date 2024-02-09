#!/bin/bash

docker run -i --rm \
    -p 9999:9999 \
    --network=host \
    --env-file ./.env.local \
    caravanacloud/rinhadebackend:latest
