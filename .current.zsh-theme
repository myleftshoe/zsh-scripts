# vim:ft=zsh ts=2 sw=2 sts=2

prompt_time() {
  echo -n "%F{8}%D{%H:%M:%S}%f"
  # elapsed is set in .zshrc precmd()
  if [[ $elapsed ]]
  then
    echo " %F{7}($elapsed ms)%f"
  fi
  echo
}

## Main prompt
build_prompt() {
   
  echo

  pwdPath="$PWD" 
  pwdLeaf=$(basename $pwdPath)

  prompt_time

  if [[ "$pwdPath" = "$HOME" ]] 
  then
    if [[ "$pwdPath" = "$_HOME" ]] 
    then
        echo -n " %F{cyan}≋%f "
    else 
        echo -n " %F{cyan}~%f "
    fi
  elif [[ "$pwdPath" = "$_HOME" ]] 
  then
      echo -n " %F{cyan}≈%f "
  fi

  is_git=$(git rev-parse --is-inside-work-tree 2> /dev/null)

  if [[ $is_git ]]
  then
 
    gitRepoPath=$(git rev-parse --show-toplevel)
    gitRepoLeaf=$(basename $gitRepoPath)

    if [[ "$pwdPath" != "$gitRepoPath" ]] 
    then 
      childPath=`echo $pwdPath | sed 's|'$gitRepoPath'/|/|'`
      echo -n "$childPath in $gitRepoLeaf"
    else 
      echo -n "$gitRepoLeaf"
    fi

    git_unstagedCount=0;
    git_stagedCount=0;
    git status --porcelain | while IFS= read -r line
    do
      firstChar=${line:0:1}
      secondChar=${line:1:1}
      if [[ $firstChar != " " ]]
      then
         ((git_stagedCount++))
      fi
      if [[ $secondChar != " " ]]
      then
         ((git_unstagedCount++))
      fi
    done
  
    git_remoteCommitDiffCount=$(git rev-list HEAD...origin/master --count 2> /dev/null)
  
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"

    branch="${ref/refs\/heads\//}"
    if [[ $branch ]]
    then
       echo -n " %F{cyan}%f"
       echo -n " %K{0}$branch"
    fi
    echo -n " %F{green}%K{0}$git_stagedCount"
    echo -n " %F{red}%K{0}$git_unstagedCount"
    echo -n " %F{yellow}%K{0}$git_remoteCommitDiffCount"

  else

    echo -n "$pwdPath"

  fi #is_git
  
  echo
  echo "%F{11}%f"

}

PROMPT='$(build_prompt) '
