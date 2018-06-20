ORGANIZATION=HeartsBRL
for i in `curl -s https://api.github.com/orgs/$ORGANIZATION/repos?per_page=200 |grep html_url|awk 'NR%2 == 0'|cut -d ':'  -f 2-3|tr -d '",'`; do  git clone $i.git ~/workspaces/hearts_erl/src/;  done
