#!/bin/bash
# Run docker container interactively.
docker run --rm -ti -v $(pwd):$(pwd) -v /dev:/dev --privileged andrsmllr/freedom-e-sdk
