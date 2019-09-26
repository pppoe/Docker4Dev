FROM nvidia/cudagl:10.0-devel-ubuntu16.04

# install ros packages
RUN apt-get update && apt-get install -y ca-certificates wget curl lsb-release
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | apt-key add -
RUN apt-get update && apt-get install -y \
      ros-kinetic-desktop-full && rm -rf /var/lib/apt/lists/*
RUN rosdep init
RUN rosdep update
RUN echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc

## some utils for Dev
RUN apt-get update && apt-get install -y feh sudo tmux vim
RUN apt-get install -y python-pip ros-kinetic-geographic-msgs libbullet-dev libsdl-image1.2-dev libsdl-dev ros-kinetic-tf2-sensor-msgs ros-kinetic-voxel-grid libgeographic-dev geographiclib-tools libsuitesparse-dev ros-kinetic-libg2o ros-kinetic-amcl ros-kinetic-yocs-cmd-vel-mux ros-kinetic-yocs-velocity-smoother
RUN pip install future

#### Begin Setting Up ENVs for Mapping X
ARG DOCKER_USER
ARG DOCKER_PASS
ARG DOCKER_UID
ARG DOCKER_GID
RUN useradd -m $DOCKER_USER && \
        echo "$DOCKER_USER:$DOCKER_PASS" | chpasswd && \
        usermod --shell /bin/bash $DOCKER_USER && \
        usermod -aG sudo $DOCKER_USER && \
        echo "$DOCKER_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$DOCKER_USER && \
        chmod 0440 /etc/sudoers.d/$DOCKER_USER && \
        usermod  --uid $DOCKER_UID $DOCKER_USER && \
        groupmod --gid $DOCKER_GID $DOCKER_USER
ENV QT_X11_NO_MITSHM=1
