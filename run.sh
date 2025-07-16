#!/bin/bash
cd `dirname $0`

docker run -d --gpus all \
  --name test-mineru \
  --shm-size 32g \
  -p 7860:7860 \
  -p 30000:30000 \
  -e MINERU_MODEL_SOURCE=modelscope \
  172.20.20.187/test-mineru:0.0.1

# docker run -d \
#   --name test-mineru \
#   --shm-size 32g \
#   -p 30000:3000 \
#   -p 7860:7860 \
#   --gpus=all \
#   docker.1ms.run/jianjungki/mineru:latest
