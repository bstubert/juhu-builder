#!/bin/bash

# argument 1: Docker image tag
# argument 2: path to Dockerfile

docker build --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" --tag "$1" $2

