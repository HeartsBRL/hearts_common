# To set up the aliases, run the following code: (without the # at the start)
# cat ~/workspaces/hearts_erl/src/hearts_common/hearts_setup/install/aliases.sh >> ~/.bashrc

# Moves to hearts_erl workspace and builds the code
alias hearts_build='source ~/workspaces/hearts_erl/devel/setup.bash && roscd && cd .. && catkin_make'
# Pulls all the repos to master
alias hearts_pull='~/workspaces/hearts_erl/src/hearts_common/hearts_setup/install/./pull_all_repos.sh'
# Pulls all the repos to master
alias hearts_check='~/workspaces/hearts_erl/src/hearts_common/hearts_setup/install/./check_all_repos.sh'
