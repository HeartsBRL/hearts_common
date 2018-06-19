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
  echo "source ~/workspaces/hearts_erl/devel/setup.bash" >> ~/.bashrc
  source ~/.bashrc

  # Pulling code:
  wget https://github.com/HeartsBRL/blob/master/hearts_common/hearts_setup/install/clone_all_repos.sh /tmp/hearts_erl_setup
  chmod +x /tmp/hearts_erl_setup/clone_all_repos.sh
  ./tmp/hearts_erl_setup/clone_all_repos.sh

  roscd && cd .. && catkin_make

fi
