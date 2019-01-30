# vim:ft=zsh ts=2 sw=2 sts=2

START_DIR=$PWD
START_BASE_DIR=$(echo "$START_DIR" | cut -d "/" -f2)
CURRENT_BG='NONE'

prompt_segment() {
  local bg fg
  fg="%F{$2}"
  bg="%b%K{$1}"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " $bg%F{$CURRENT_BG}$fg "
  else
    echo -n "$bg$fg "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  echo -n "%K{$CURRENT_BG} %k%F{$CURRENT_BG}%f"
  CURRENT_BG=''
}

# Git: branch/detached head, dirty status
prompt_git() {

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1)
  then
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
    prompt_segment 7 black
    echo -n "${ref/refs\/heads\// }"
    echo -n " %F{green}%K{7}$git_stagedCount"
    echo -n " %F{red}%K{7}$git_unstagedCount"
    echo -n " %F{yellow}%K{7}$git_remoteCommitDiffCount"
  fi
}

prompt_root() {
  local relativePath baseDir
  baseDir=${(U)$(echo "$PWD" | cut -d "/" -f2)}
   if [[ -z $baseDir ]]
   then
      baseDir="(ROOT)"
   fi
  prompt_segment 5 15 "$baseDir"
}

prompt_logo() {
#  prompt_segment 9 gray ""
  echo -n "%K{5}%F{gray} "
  echo -n "%K{5}%F{black} ⎪"
}

prompt_dir() {
  local relativePath baseDir
  baseDir=$(echo "$PWD" | cut -d "/" -f2)
  relativePath=$(basename $PWD)
  if [[ $relativePath = $baseDir ]] 
  then
    relativePath=""
  fi
  if [[ $relativePath = "/" ]] 
  then
    relativePath=""
  fi
  prompt_segment 13 15 "$relativePath"
}

prompt_time() {
  echo -n "%F{13}%D{%H:%M:%S}"
  if [[ $elapsed ]]
  then
    echo -n " %F{7}($elapsed ms)"
  fi
  echo
}

## Main prompt
build_prompt() {
  echo #insert blank line before each prompt
  prompt_time
  prompt_logo
  prompt_root
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='$(build_prompt) '
