FROM ubuntu:focal

ARG CARLA_RELEASE=0.9.13

# Install core packages required to install from external repos
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        gnupg2 \
        software-properties-common \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

# Setup the CARLA Ubuntu repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1AF1527DE64CB8D9
RUN add-apt-repository "deb [arch=amd64] http://dist.carla.org/carla focal main"

# Install CARLA
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        carla-simulator=${CARLA_RELEASE} \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 

# Install missing CARLA dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install \
        xdg-user-dirs \
        xdg-utils \
        libsdl2-2.0 \
        xserver-xorg \
        libomp5 \
    && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* 
    
# Install ROS Foxy 
RUN sudo apt update && sudo apt install locales \
&& sudo locale-gen en_US en_US.UTF-8 \
&& sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
&& export LANG=en_US.UTF-8 \
&& sudo apt install software-properties-common \
&& sudo add-apt-repository universe \
&& sudo apt update && sudo apt install curl -y \
&& sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
 -o /usr/share/keyrings/ros-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null \
&& sudo apt update && sudo apt upgrade \
&& sudo apt install ros-foxy-ros-base python3-argcomplete \
&& sudo apt install ros-dev-tools # Installing ROS dev tools

# Install ROS Bridge
RUN mkdir -p ~/carla-ros-bridge && cd ~/carla-ros-bridge \
&& git clone --recurse-submodules https://github.com/carla-simulator/ros-bridge.git src/ros-bridge \
&& source /opt/ros/foxy/setup.bash \
&& rosdep update \
&& rosdep install --from-paths src --ignore-src -r \
&& colcon build

# Make server ports accessible outside container
EXPOSE 2000-2002

# Add a container user (good practice)
RUN groupadd work -g 1000 \
   && useradd -ms /bin/bash carla -g 1000 -u 1000 \
   && printf "carla:carla" | chpasswd \
   && printf "carla ALL= NOPASSWD: ALL\\n" >> /etc/sudoers
    
USER carla
WORKDIR /home/carla/

# Run the server
RUN source /opt/carla-simulator/CarlaUE4.sh \
&& export CARLA_ROOT=/home/carla/ \
&& export PYTHONPATH=$PYTHONPATH:$CARLA_ROOT/PythonAPI/carla/dist/carla-${CARLA_RELEASE}-py3.8-linux-x86_64.egg:$CARLA_ROOT/PythonAPI/carla \
&& source ./install/setup.bash

RUN ros2 launch carla_ros_bridge carla_ros_bridge.launch.py

ENTRYPOINT ["/opt/carla-simulator/CarlaUE4.sh"]

