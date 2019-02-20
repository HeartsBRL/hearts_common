#!/bin/bash
#############################################################################################
# script  : check_all_repos_and_report.sh
# author  : Derek Rpper
# Created : 17 Feb 2018
# Purpose : To check the status of all HEARTS repositories in ~/workspaces/hearts_erl/src
#           Based on check_all_repos.sh BUT now a file is writtenof all data that needed
#           to be reviewed. File is: /home/$USER/repo_report.txt 
#############################################################################################
# Updates:
#############################################################################################

function fnc_writeheader() {
    echo "----------    GIT Repsoitory Report  ----------"   >  $REPORTFILE
    echo                                                     >> $REPORTFILE
    echo "Workspace: $PULL_DIR"                              >> $REPORTFILE
    echo "Created  : $DATE"                                  >> $REPORTFILE
    echo "By       : $USER"                                  >> $REPORTFILE
    echo "-----------------------------------------------"   >> $REPORTFILE
} # end of function fn_writeheader

function fnc_writereport() {
############################################################################
# arg 1: repo name
# arg 2: report file NB pass name only - NO Prefixed $ - ie passed by Reference
# arg 3: Flag to avoid mutple listing of report if more than on issue found.
############################################################################  


local -n content=$2 #allows arg2 to be passed by reference (not by value)
local -n rptflag=$3 

if [ $rptflag == 0  ]; then
    echo -e "\n#########################################################################" >> $REPORTFILE
    echo    "##### GIT REPOSITORY : $1  --- $3 "                                          >> $REPORTFILE        
    echo -e "#########################################################################"   >> $REPORTFILE
    echo    "$content"                    >> $REPORTFILE
    echo -e "\n##### Review Issue(s)"     >> $REPORTFILE
fi

# update correct flag variable
if fnc_has_substring $3 "GIT"
    then
    GIT_STATUS=1  # true - one git satus report already printed  
fi


if fnc_has_substring $3 "BRANCH"
    then    
    BRANCH_STATUS=1 # true -  one branch status report already printed  
fi
} # end of function fnc_writereport

function fnc_has_substring () {
######################################
# arg 1: string to  be searched
# arg 2: substring to be found
#
# evaluates to True if substring found
######################################    

if [[ $1 =~ $2 ]] 
then
    return 0 # false
else 
    return 1 # true
fi
} #end of function fnc_has_substring


##############################################################################################
#                                Start of main script code
##############################################################################################
set -u # Do not allow undefined variables!

DATE=`date`
REPORTFILE="/home/$USER/repo_report.txt"
PULL_DIR=~/workspaces/hearts_erl/src

fnc_writeheader 

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

declare -i GIT_STATUS=0
declare -i BRANCH_STATUS=0


# store the current dir
CUR_DIR=$(pwd)



# initialise to empty files
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
    GIT_STATUS=0
    BRANCH_STATUS=0

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

    echo -e "$YELLOW ########### $i  -  CHECKed Branch is: $GREEN$ACTIVEBRANCH$NORM"
    echo 'Repository: ' $i  --   'current CHECKed branch: ' $ACTIVEBRANCH >>$TEMPDIR
    echo ""
    # Dispaly git status report to the screen 
    git status
    # and store a copy of the report for analysis
    GITREPORT=`git status`

    # list all Local & Remote branches
    echo
    echo "########## LOCAL/REMOTE : Branches:"
    # only list if needed
    #git branch -av
    BRANCHREPORT=`git branch -av`
    echo "##########    END for all Branches:"

    # Summarise informative  messages from the git status report  
    echo $GITREPORT | grep -i  'working directory clean' > /dev/null
    if [ $? != 0 ] ; then
        fnc_writereport $i GITREPORT GIT_STATUS
        notclean=$notclean+1 
        echo '##### Issue is: Local working directory is not clean!' >> $REPORTFILE
    fi    

    echo $GITREPORT | grep -i  "fatal\|error" > /dev/null
    if [ $? == 0 ] ; then
        fnc_writereport $i GITREPORT GIT_STATUS
        echo '##### Issue is: Error found in git status report' >> $REPORTFILE
        numerror=$numerror+1
    fi  

    echo $GITREPORT | grep   'HEAD detached' > /dev/null
    if [ $? == 0 ] ; then
        fnc_writereport $i GITREPORT GIT_STATUS
        echo '##### Issue is: Detached HEAD in git status report' >> $REPORTFILE
        numheads=$numheads+1
    fi  
    # 'ahead' is covered in branch report so removed
    # echo $GITREPORT | grep   'branch is ahead' > /dev/null
    # if [ $? == 0 ] ; then
    #     aheads=$aheads+1
    # fi

    echo $BRANCHREPORT | grep   '\[behind' > /dev/null
    if [ $? == 0 ] ; then
        fnc_writereport $i BRANCHREPORT BRANCH_STATUS
        echo '##### Issue is: BEHIND in branch status report' >> $REPORTFILE
        behinds=$behinds+1
    fi

    echo $BRANCHREPORT | grep   '\[ahead' > /dev/null
    if [ $? == 0 ] ; then
        fnc_writereport $i BRANCHREPORT BRANCH_STATUS
        echo '##### Issue is: AHEAD  in branch status report' >> $REPORTFILE        
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
        echo "##### Issue is: Local Repository out of date with remote - see report below:" >> $REPORTFILE
        git remote show origin                                           >> $REPORTFILE
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
echo "******"
echo -e "****** See Report in: $YELLOW $REPORTFILE $GREEN for details"
echo "******           of repositories needing review!"
echo "******"
echo "****************************************************************"
echo -e $NORM
