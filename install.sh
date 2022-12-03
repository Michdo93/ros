#!/bin/sh
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt-get upgrade

sudo apt install -y python3-rosdep python3-rosinstall-generator python3-wstool python3-rosinstall build-essential cmake

sudo apt install python3-catkin python3-catkin-lint python3-catkin-pkg python3-catkin-pkg-modules python3-catkin-tools

sudo rosdep init --rosdistro noetic
rosdep update --include-eol-distros

mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws

rosinstall_generator ros_comm --rosdistro noetic --deps --wet-only --tar > noetic-ros_comm-wet.rosinstall
wstool init src noetic-ros_comm-wet.rosinstall

cd ~/ros_catkin_ws
rosdep install -y --from-paths src --ignore-src --rosdistro noetic -r --os=debian:buster

cd ~/ros_catkin_ws/src && for d in genmsg genpy gencpp geneus gennodejs genlisp ; do (cd "$d" && sudo pip3 install -e .); done && cd ..

cd ~/ros_catkin_ws
sudo src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/noetic -j1 -DPYTHON_EXECUTABLE=/usr/bin/python3

echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

mkdir -p ~/catkin_ws/src
cd catkin_ws
catkin_make
echo "source /home/pi/catkin_ws/devel/setup.bash" >> ~/.bashrc
