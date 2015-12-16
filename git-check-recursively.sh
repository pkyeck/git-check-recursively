#!/bin/bash

WHTIEBOLD="\x1B[97;1m"
YELLOWBOLD="\x1B[32;1m"
ORANGE="\x1B[33m"
RED="\x1B[31m"
RESET="\x1B[0m"

for gitdir in `find ./ -name .git`; do 
  workdir=${gitdir%/*}; 
  currentBranch=`git --git-dir=$gitdir --work-tree=$workdir rev-parse --abbrev-ref HEAD 2> /dev/null | sed 's#\(.*\)#\1#'`;
  
  if [[ "$currentBranch" = "master" ]]; then
    currentColor=${YELLOWBOLD}
  else
    currentColor=${ORANGE}
  fi;
  
  echo -e "\n${WHTIEBOLD}${workdir}${RESET} ${currentColor}/${currentBranch}${RESET}";

  git --git-dir=$gitdir --work-tree=$workdir for-each-ref --format="%(refname:short) %(upstream:short)" refs/ | \
  while read local remote; do
    if [ -x $remote ]; then
      branches=("$local")
    else
      branches=("$local" "$remote")
    fi;

    for branch in ${branches[@]}; do
        if [ "$branch" != "origin/master" ]; then
          master="origin/master"

          git --git-dir=$gitdir --work-tree=$workdir rev-list --left-right ${branch}...${master} -- 2>/dev/null >/tmp/git_upstream_status_delta || continue
  
          LEFT_AHEAD=$(grep -c '^<' /tmp/git_upstream_status_delta)
          RIGHT_AHEAD=$(grep -c '^>' /tmp/git_upstream_status_delta)
    
          if [[ $LEFT_AHEAD -gt 0 || $RIGHT_AHEAD -gt 0 ]]; then
            if [ "$branch" != "master" ]; then
              currentColor=${ORANGE};
            else
              currentColor=${RED};
            fi;

            echo -e "${currentColor}  !! $branch (ahead $LEFT_AHEAD) | (behind $RIGHT_AHEAD) $master ${RESET}"
          fi;
        fi;
    done
  done | sort | uniq

  git --git-dir=$gitdir --work-tree=$workdir status -s | sed 's/^/  /';
done
