# vim:ft=zsh ts=2 sw=2 sts=2


prompt_time() {
#  echo -n "   %F{11}%f "
  echo -n "%F{8}%D{%H:%M:%S}%f"
  # elapsed is set in .zshrc precmd()
  if [[ $elapsed ]]
  then
    echo -n " ($elapsed ms)"
  fi
  echo
}

## Main prompt
build_prompt() {

  pwdPath="$PWD" 
  pwdLeaf=$(basename $pwdPath)
  pwdParentPath=${pwdPath:a:h}

  if [[ $timer = "on" ]]
  then
     prompt_time
  fi

  folderIcon=""
  if [[ "$pwdPath" = "$HOME" ]] 
  then
    if [[ "$pwdPath" = "$_HOME" ]] 
    then
        folderIcon="≋"
    else 
        folderIcon="~"
    fi
  elif [[ "$pwdPath" = "$_HOME" ]] 
  then
      folderIcon="≈"
  fi

  # Line 1
  echo -n "%F{$promptColor}┏━ $folderIcon%f"
  echo -n " $pwdLeaf"
  if [[ "$pwdLeaf" != "$pwdPath" ]] {
      echo -n " %F{8} $pwdParentPath%f" 
  }

  echo

  # Line 2
  is_git=$(git rev-parse --is-inside-work-tree 2> /dev/null)
  if [[ $is_git ]]
  then
 
	echo -n "%F{$promptColor}┃%f "
 
	gitLogo=""
	gitBranchIcon=""

    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"

	git_branch="${ref/refs\/heads\//}";
    
    if [[ -z "$git_branch" ]]
    then
   		git_branch="(none)"
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

    gitRepoPath=$(git rev-parse --show-toplevel)
    gitRepoLeaf=$(basename $gitRepoPath)

    gitRemoteName=${$(basename $(git remote get-url origin)):r}

    if [[ "$pwdPath" != "$gitRepoPath" ]] 
	then
        echo -n " %F{11}$gitLogo%f "
        echo -n "$gitRepoLeaf"
   fi 

    echo -n " %F{11}$gitBranchIcon%f"
    echo -n " $git_branch"
    echo -n " %F{green}$git_stagedCount"
    echo -n " %F{red}$git_unstagedCount"
    echo -n " %F{11}$git_remoteCommitDiffCount"
    
    if [[ "$gitRemoteName" != "$gitRepoLeaf" ]] 
    then
        echo -n " %F{11}肋%f"
        echo -n "$gitRemoteName"
	fi    
    echo
  fi #is_git
  
  echo "%F{$promptColor}┗%f"

}

PROMPT='$(build_prompt) '
