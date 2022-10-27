# Installing ROS Noetic on Raspberry Pi

Hello Everyone. I've been trying to install ROS Noetic on Raspbian GNU/Linux 10 (buster) 
from source but it was like a nightmare. Finally, I was able to install it and I want to share it with you.
## Steps:
 

    $ sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    $ sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    $ sudo apt-get update
    $ sudo apt-get upgrade

### Install Bootstrap Dependencies

    $ sudo apt install -y python3-rosdep python3-rosinstall-generator python3-wstool python3-rosinstall build-essential cmake

### These Dependencies are also required 

    sudo apt install python3-catkin python3-catkin-lint python3-catkin-pkg python3-catkin-pkg-modules python3-catkin-tools


### Initializing rosdep

    $ sudo rosdep init --rosdistro noetic
    $ rosdep update --include-eol-distros
### Create a catkin Workspace

    $ mkdir -p ~/ros_catkin_ws
    $ cd ~/ros_catkin_ws

### Fetch ROS pacakges 

    $ rosinstall_generator ros_comm --rosdistro noetic --deps --wet-only --tar > noetic-ros_comm-wet.rosinstall
    $ wstool init src noetic-ros_comm-wet.rosinstall

replace **ros_comm** with **desktop** if you wish to install GUI tools like Rviz, Rqt, and robot-generic libraries.
### Resolve Dependencies

    $ cd ~/ros_catkin_ws
    $ rosdep install -y --from-paths src --ignore-src --rosdistro noetic -r --os=debian:buster

### Install messages generation libraries manually
We need to manually install these Python3 packages from src folder

 1. gencpp 
 2. geneus 
 3. genlisp 
 4. genmsg 
 5. gennodejs 
 6. genpy

The following command loops through each directory and install the python package

    $ cd src && for d in genmsg genpy gencpp geneus gennodejs genlisp ; do (cd "$d" && sudo pip3 install -e .); done && cd ..

### Building the catkin Workspace

    sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/noetic -j2

Now ROS should be installed! Remember to source the new installation:

    $ echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

