#! /bin/bash

if [ $# -lt 1 ]; then
  echo "Usage:- DockerImageName"
  exit
fi

DockerImageName=$1

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

sudo nvidia-docker run --rm -it \
        --shm-size=4096m \
        -v /data:/data \
        --volume=$HOME:/home/${USER} \
        --volume=$XSOCK:$XSOCK:rw \
        --volume=$XAUTH:$XAUTH:rw \
        --env="XAUTHORITY=${XAUTH}" \
        --env="DISPLAY" \
        --user="$USER" \
        -v $PWD:/workspace $DockerImageName bash
