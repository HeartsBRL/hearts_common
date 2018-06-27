# Installation Guide:

```
cd ~
wget https://raw.githubusercontent.com/HeartsBRL/hearts_common/master/hearts_setup/install/install.sh
chmod +x ~/install.sh
./install.sh
```

## Optional extras: 

### Install Aliases:
```
cat ~/workspaces/hearts_erl/src/hearts_common/hearts_setup/install/aliases.sh >> ~/.bashrc
```

### Install OpenCV3 with contribs:
### @NOTE: This currently isn't solving the dependency issue. So you'll have a nice install of opencv3 but the code won't compile.
```
./workspaces/hearts_erl/src/hearts_common/hearts_setup/install_opencv3.sh
```

# Tiago Base Machine Install:

### @NOTE: These need to be checked, but should help along the process.

Setup instructions for the machine connected to Tiago. More information about multiple machines on ROS can be found here: http://wiki.ros.org/ROS/Tutorials/MultipleMachines & http://wiki.ros.org/ROS/NetworkSetup.

These need to be ADDED, please don't overwrite the files.

/etc/hosts
```
10.68.0.1	control	tiago-25c
```

~/.bashrc
```
#### Universal ROS Settings:

source /opt/ros/indigo/setup.bash
source /home/${USER}/hearts_erl/devel/setup.bash

#### Tiago Networking: ethernet address
export ROS_MASTER_URI=http://10.68.0.1:11311/
export ROS_IP=10.68.0.129
```
