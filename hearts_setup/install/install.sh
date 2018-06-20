#!/bin/bash

# Init

## store current directory
CUR_DIR=$(pwd)

## set up tmp area
mkdir /tmp/hearts_erl_setup

# Only run if the workspace doesn't already exist:
if [ ! -d "~/workspaces/hearts_erl" ]; then

  # Installation:

  ## Make directory
  if [ ! -d "~/workspaces" ]; then
    mkdir ~/workspaces && cd ~/workspaces
  fi
  mkdir hearts_erl && cd hearts_erl
  mkdir src && cd src

  ## init and make the workspace
  catkin_init_workspace
  cd ~/workspaces/hearts_erl
  catkin_make

  ## Add config to ~/.bashrc file
  echo "source ~/workspaces/hearts_erl/devel/setup.bash " >> ~/.bashrc
  source ~/.bashrc

  # Pulling code:
  wget https://raw.githubusercontent.com/HeartsBRL/hearts_common/master/hearts_setup/install/clone_all_repos.sh -P /tmp/hearts_erl_setup
  chmod +x /tmp/hearts_erl_setup/clone_all_repos.sh
  /tmp/hearts_erl_setup/./clone_all_repos.sh

  # Installing opencv3:
  #chmod +x ~/workspaces/hearts_erl/src/hearts_common/hearts_setup/install_opencv3.sh
  #./workspaces/hearts_erl/src/hearts_common/hearts_setup/install_opencv3.sh

  # build the code:
  roscd && cd .. && catkin_make

  # make scripts executable
  chmod +x ~/workspaces/hearts_erl/src/hearts_common/hearts_setup/install/*.sh

fi
