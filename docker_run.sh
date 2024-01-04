#!/bin/bash
docker run --rm --workdir /home --volume $PWD:/home macosboot:latest ./create-image.sh