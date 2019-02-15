#!/bin/bash
#############################################################################################
# script  : check_all_repos_and_report.sh
# author  : Alex Sleat
# Created : October 2018
# Purpose : To check the status of all HEARTS repositories in ~/workspaces/hearts_erl/src
#
#############################################################################################
# Updates:
# 24 Nov 2018 Derek - restored colour ouput from git to the screen
#                   - added counters for report content for: not clean, errors or detached head
#                         etc, !there may be others?
#                   - added list of repositores for completeness in the summary of findings
#                   - added list of local/remote branches by repo:                  
#                   - added code for special case of sub module in at_home_rsbb_comm_ros/comm
#
# 06 Dec 2018 Derek - Change notation for aheads/behinds as they are for all Branches
#                   - Now check only  BRANCHREPORT for aheads to avoid duplication of count
#                   - User will be best redkrecting report to file for detailed review
#                    ie:  ./check_all_repos.sh > mysummary.txt
#                   - for ahead and behind detection adding an "Escaped ["    for  uniqueness
#
# 04 Feb 2019 Derek - as previous vesion but to write a text file report by repository.
#                     Hence being able to go straight to issues that have been rasied.
#############################################################################################
set -u

# set up colours
GREEN="\033[32m"
YELLOW="\033[33m"
NORM="\033[0m"

# temp file
TEMPDIR=~/very_very.tmp

# initialise counters
declare -i notclean=0
declare -i numrepos=0
declare -i numerror=0
declare -i numheads=0
declare -i aheads=0
declare -i behinds=0
declare -i onmaster=0
declare -i repobehind=0

DATE=`date`

# store the current dir
CUR_DIR=$(pwd)

PULL_DIR=~/workspaces/hearts_erl/src

# initialise temp file
echo > $TEMPDIR


cd $PULL_DIR

# Let the person running the script know what's going on.
echo -e $YELLOW
echo
echo "***********************************************************"
echo "***** Checking the status of all git repositories in: *****"
echo "***** $PULL_DIR"
echo "***********************************************************"
echo "***** on $DATE"
echo "***********************************************************"
echo -e $NORM

# Find all git repositories 
for i in $(find . -name ".git" | cut -c 3-); do
    numrepos=$numrepos+1
    # We have to go to the .git parent directory to execute "git status"
    # but handle special case of RSBB which has a .git 'file' not 'directory!'
    echo $i | grep 'ros/comm'  > /dev/null
    if [ $? == 0 ] ; then
       echo "RSBB git submodule area -- It is updated as a submodule which is different from normal!" 
       echo "                           see ERL RSBB install documentation."
       echo
       commdir=`echo $i | sed -e s/.git//` #strip offf .git repo file name so that "cd" works
       cd $commdir
    else
       cd "$i";
       cd ..
    fi

    ACTIVEBRANCH=`git branch | grep \* | cut -c  3-`

    echo -e "$YELLOW ########### $i  -  CHECKOUT Branch is: $GREEN$ACTIVEBRANCH$NORM"
    echo 'Repository: ' $i  --   'current CHECKOUT branch: ' $ACTIVEBRANCH >>$TEMPDIR
    echo ""
    # Dispaly git status report to the screen 
    git status
    # and store a copy of the report for analysis
    GITREPORT=`git status`

    # list all Local & Remote branches
    echo
    echo "########## LOCAL/REMOTE : Branches:"
    git branch -av
    BRANCHREPORT=`git branch -av`
    echo "##########    END for all Branches:"

    # Summarise informative  messages from the git status report  
    echo $GITREPORT | grep -i  'working directory clean' > /dev/null
    if [ $? != 0 ] ; then
        notclean=$notclean+1
    fi    

    echo $GITREPORT | grep -i  "fatal\|error" > /dev/null
    if [ $? == 0 ] ; then
        numerror=$numerror+1
    fi  

    echo $GITREPORT | grep   'HEAD detached' > /dev/null
    if [ $? == 0 ] ; then
        numheads=$numheads+1
    fi  
    # 'ahead' is covered in branch report so removed
    # echo $GITREPORT | grep   'branch is ahead' > /dev/null
    # if [ $? == 0 ] ; then
    #     aheads=$aheads+1
    # fi

    echo $BRANCHREPORT | grep   '\[behind' > /dev/null
    if [ $? == 0 ] ; then
        behinds=$behinds+1
    fi

    echo $BRANCHREPORT | grep   '\[ahead' > /dev/null
    if [ $? == 0 ] ; then
        aheads=$aheads+1
    fi

    echo $GITREPORT | grep   'On branch master' > /dev/null
    if [ $? == 0 ] ; then
        onmaster=$onmaster+1    
    fi  

    # check if local repo out of date with'remote'
    echo -e $YELLOW'----------------- Check "local repo" to "remote repo" status'
    git remote show origin | grep -i "local out of date"
    if [ $? == 0 ] ; then
        repobehind=$repobehind+1
    fi    
    
    echo "______________________________________________________________";
    echo -e $NORM

    # lets get back to the PULL_DIR
    cd $PULL_DIR
done

cd $CUR_DIR

echo ""
echo "TOTAL Number of .git repositories detected       : "$numrepos
echo
echo 'List of repositories:'
echo

find $PULL_DIR -name '.git'

echo -e $YELLOW
echo "List of any repositiries where master is NOT the current checked out branch:"
cat $TEMPDIR | grep -v master
rm  $TEMPDIR
echo -en $NORM

echo
echo "TOTAL Number of .git repositories detected       : "$numrepos
echo "Number of .git repositoies CHECKOUT as master'   : "$onmaster
echo
echo "****************************************************************************"
echo "***** Please review any messages reported below with a non-zero count! *****"
echo "****************************************************************************"
echo
echo "Number of .git repositories  ## NOT clean !! ##    : "$notclean
echo "Number of .git repositories where repo   is behind : "$repobehind "- pull needed"
echo "         *** Counts are For ALL Branches ***         "
echo "Number of .git repositories where branch is behind : "$behinds    "- pull needed"
echo "Number of .git repositories where branch is ahead  : "$aheads     "- push nedded"
echo
echo "Number of .git repositories with HEAD detached     : "$numheads
echo
echo -e $GREEN
echo "****************************************************************"
echo "****** ALL DONE in: $0"
echo "****** on $DATE"
echo "****************************************************************"
echo -e $NORM
