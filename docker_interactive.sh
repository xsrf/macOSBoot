#!/bin/bash
docker run --rm --workdir /home --volume $PWD:/home -ti --entrypoint bash macosboot:latest