#!/bin/bash
cd `dirname $0`

docker stop test-mineru
docker rm test-mineru
