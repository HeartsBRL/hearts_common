#!/bin/bash
#############################################################################################
# author  : Alex Sleat
# Created : October 2018
# Purpose : To check the status of all HEARTS repositories in ~/workspaces/hearts_erl/src
#s
#############################################################################################
# Updates:
# 22 Nov 2018 Derek - restored colour ouput from git to the screen
#                   - added counters for report content for: not clean, errors or detached head
#                     !there may be others?s
#                   - added list of repositores for completeness in the summary of findings
#                   - added code for special case of sub module in at_home_rsbb_comm_ros/comm
#
#############################################################################################
declare -i notclean=0
declare -i numrepos=0
declare -i numerror=0
declare -i numheads=0
declare -i aheads=0

# store the current dir
CUR_DIR=$(pwd)

PULL_DIR=~/workspaces/hearts_erl/src

cd $PULL_DIR

# Let the person running the script know what's going on.
echo
echo "*******************************************************"
echo "***** Checking the status of all git repositories *****"
echo "*******************************************************"

# Find all git repositories 
for i in $(find . -name ".git" | cut -c 3-); do
    numrepos=$numrepos+1
    echo "";
    echo "########### $i";
    echo ""

    # We have to go to the .git parent directory to execute "git status"
    # but handle special case of RSBB which has a .git 'file' not 'directory!'
    echo $i | grep 'ros/comm'  > /dev/null
    if [ $? == 0 ] ; then
       echo "RSBB git submodule area -- It is updated as a submodule which is different from normal!" 
       echo "                           see ERL RSBB install documentation."
       echo
       commdir=`echo $i | sed -e s/.git//`
       cd $commdir
    else
       cd "$i";
       cd ..
    fi

    # check status - display to screen
    git status ;

    # look for informative  messages in the git status reports
    git status | grep -i  'working directory clean' > /dev/null
    if [ $? != 0 ] ; then
        notclean=$notclean+1
    fi    

    git status | grep -i  "fatal\|error" > /dev/null
    if [ $? != 0 ] ; then
        numerror=$numerrors+1
    fi  

    git status | grep   'HEAD detached' > /dev/null
    if [ $? == 0 ] ; then
        numheads=$numheads+1
    fi  

    git status | grep   'branch is ahead' > /dev/null
    if [ $? == 0 ] ; then
        aheads=$aheads+1
    fi  
    echo "______________________________________________________________";
    # lets get back to the PULL_DIR
    cd $PULL_DIR
done
cd $PULL_DIR
echo ""
echo "TOTAL Number of .git repositories detected        : "$numrepos
echo
echo 'List of repositories:'
echo
find . -name '.git'
echo
echo "TOTAL Number of .git repositories detected        : "$numrepos
echo "****************************************************************************"
echo "***** Please review any messages reported below with a non-zero count! *****"
echo "****************************************************************************"
echo
echo "Number of .git repositoies  ## NOT clean !! ##    : "$notclean
echo "Number of .git repositoies  where branch is ahead : "$aheads
echo "Number of .git repositoies with Errors detected   : "$numerror
echo "Number of .git repositoies  with HEAD detached    : "$numheads
cd $CUR_DIR
echo
echo "****************************************************************"
echo "****** ALL DONE in: $0"
echo "****************************************************************"

