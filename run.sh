#!/bin/sh

docker \
  run \
  -it \
  -p 8008:8888 \
  -v $(pwd):/home/jovyan/work \
  --workdir=/home/jovyan/work \
  maesyori:v0.0
