#!/bin/bash
set -e
IMAGE_NAME="naliniselv/react-app"
TAG=${git rev-parse --short HEAD}
docker build -t $IMAGE_NAME:$TAG .
docker tag $IMAGE_NAME:$TAG $IMAGE_NAME:latest
docker push $IMAGE_NAME:latest
