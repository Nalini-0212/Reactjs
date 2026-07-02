#!/bin/bash
set -e
IMAGE_REPO_NAME="naliniselv/react-app:latest"
CONTAINER_NAME="react-app-container"
docker pull $IMAGE_REPO_NAME
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true
docker run -d --name $CONTAINER_NAME -p 80:80 $IMAGE_REPO_NAME