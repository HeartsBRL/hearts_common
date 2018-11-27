#!/bin/bash
#############################################################################################
# author  : Alex Sleat
# Created : October 2018
# Purpose : To update ALL local repoitories with the remote GitHub HEARTS repro
#
#############################################################################################
# Updates:
# 26 Nov 2018 Derek - added error trapping after pull command
#                   - added colour to displayed text + more info
#                   - added 'active branch' printed for each repo
#
#############################################################################################
# do NOT allow undefined variables
set -u

# initialise counters
declare -i numrepos=0
declare -i pullerror=0
declare -i submoderror=0


# set up colours
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
NORM="\033[0m"


DATE=`date`

# store the current dir
CUR_DIR=$(pwd)

PULL_DIR=~/workspaces/hearts_erl/src

cd $PULL_DIR

# Let the person running the script know what's going on.
echo -e $YELLOW
echo "*******************************************************"
echo "***** pulling updates for all git repositories in *****"
echo "*****" $PULL_DIR
echo "*******************************************************"
echo "*****  on $DATE"
echo "*******************************************************"
echo -e $NORM


# Find all git repositories and update it to the master latest revision
for i in $(find . -name ".git" | cut -c 3-); do
    echo -e "$YELLOW########### $i $NORM"
    numrepos=$numrepos+1

    # We have to go to the .git parent directory to execute "git pull"
    # but handle special case of RSBB which has a .git 'file' not 'directory!'
    echo $i | grep 'ros/comm'  > /dev/null
    if [ $? == 0 ] ; then
        echo "RSBB git submodule area -- It is updated as a submodule which is different from normal!" 
        echo "                           see ERL RSBB install documentation."
        echo
        commdir=`echo $i | sed -e s/.git//` #strip offf .git repo file name so that "cd" works
        cd $commdir
        #git pull origin master
        if [ $? != 0 ] ; then
            pullerror=$pullerror+1
        fi      

        git submodule update --init
        if [ $? != 0 ] ; then
            submoderror=$submoderror+1 
        fi

    else
        cd "$i";
        cd ..
        git pull origin master
        if [ $? != 0 ] ; then
            pullerror=$pullerror+1
        fi         
    fi

    ACTIVEBRANCH=`git branch | grep \* | cut -c  3-`
    
    echo -e "$YELLOW########### $i  -  CHECKOUT Branch is: $GREEN$ACTIVEBRANCH$NORM"


    echo "______________________________________________________________";
    # lets get back to the PULL_DIR
    cd $PULL_DIR
done

cd $CUR_DIR

echo
echo "TOTAL Number of .git repositories processed            : "$numrepos
echo
echo 'List of repositories:'
echo

find $PULL_DIR -name '.git'

echo -e $RED
if [ $pullerror != 0 ] ; then
    echo "TOTAL Number of 'pull' error(s) detected               : "$pullerror
fi  

if [ $submoderror != 0 ] ; then
    echo "TOTAL Number of 'pull' error(s) foe sub module detected: "$submoderror
fi
echo -e $GREEN
echo "****************************************************************"
echo "****** ALL DONE in: $0"
echo "****** on $DATE"
echo "****************************************************************"
echo -e $NORM
