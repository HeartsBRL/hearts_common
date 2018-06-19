#!/bin/bash

# store the current dir
CUR_DIR=$(pwd)

PULL_DIR=~/workspaces/hearts_erl/src

cd $PULL_DIR

# Let the person running the script know what's going on.
echo "Checking all repos status"

# Find all git repositories and update it to the master latest revision
for i in $(find . -name ".git" | cut -c 3-); do
    echo "";
    echo "########### $i";
    echo ""

    # We have to go to the .git parent directory to call the pull command
    cd "$i";
    cd ..;

    # finally pull
    git status | sed 's/^/  /';

    echo "______________________________________________________________";

    # lets get back to the CUR_DIR
    cd $PULL_DIR
done

cd $CUR_DIR

echo ""
echo "Complete!"
