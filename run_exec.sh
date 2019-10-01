#!/bin/bash
# Run docker image like an executable, e.g. './run_exec.sh upload PRGORAM=hello BOARD=sifive-hifive1'
docker run --rm -ti --privileged -v /dev:/dev -v $(pwd):$(pwd) --entrypoint=/usr/bin/make --workdir=/opt/freedom-e-sdk andrsmllr/freedom-e-sdk $@
