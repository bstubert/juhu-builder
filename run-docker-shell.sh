#!/bin/bash

# argument 1: Docker image tag

docker run -it --rm -v $PWD:/public/Work $1

