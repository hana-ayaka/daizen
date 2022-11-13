#!/bin/sh

docker \
  run \
  -it \
  -p 8008:8888 \
  --platform=linux/amd64 \
  -v $(pwd):/home/jovyan/work \
  --workdir=/home/jovyan/work \
  jupyter/datascience-notebook:bada6c21e945

