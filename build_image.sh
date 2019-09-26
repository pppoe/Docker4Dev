#! /bin/bash

DOCKER_USER_NAME=$USER
DOCKER_UID=$(id -u)
DOCKER_GID=$(id -g)

if [ $# -lt 2 ]; then
  echo "DockerImageName DockerfilePath"
  exit
fi

echo -n Password:
read -s DOCKER_PASS
echo

DOCKER_IMAGE_NAME=$1
DockerfilePath=$2

if [ ! -f $DockerfilePath ]; then
  echo "Not found $DockerfilePath"
  exit
fi

# Run Command
echo "DOCKER_USER_NAME: $DOCKER_USER_NAME"
echo "DOCKER_UID: $DOCKER_UID"
echo "DOCKER_GID: $DOCKER_GID"
sudo nvidia-docker build \
  --build-arg DOCKER_USER_NAME=$DOCKER_USER_NAME \
  --build-arg DOCKER_PASS=$DOCKER_PASS \
  --build-arg DOCKER_UID=$DOCKER_UID \
  --build-arg DOCKER_GID=$DOCKER_GID \
  -t $DOCKER_IMAGE_NAME -f $DockerfilePath .
