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

  local ref dirty
  
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment 11 black 
      echo -n "${ref/refs\/heads\// }"
    elif [[ $(git rev-list HEAD...origin/master --count) -ne 0 ]] ; then
      prompt_segment green black
      echo -n "${ref/refs\/heads\// }"
    fi
#   echo -n "${ref/refs\/heads\// }$dirty"
  fi
}

prompt_root() {
#  prompt_segment blue 5 '%~'
  local relativePath baseDir
  baseDir=${(U)$(echo "$PWD" | cut -d "/" -f2)}
   if [[ -z $baseDir ]]
   then
      baseDir="(ROOT)"
   fi
  prompt_segment 9 15 "$baseDir"
# echo -n "%F{15}%K{9} $baseDir "
# echo -n "%F{7}"
}

prompt_logo() {
#  prompt_segment 9 gray ""
  echo -n "%K{9}%F{gray} "
  echo -n "%K{9}%F{black} ⎪"
}

prompt_dir() {
#  prompt_segment blue 5 '%~'
  local relativePath baseDir
  baseDir=$(echo "$PWD" | cut -d "/" -f2)
# if [[ $baseDir != $START_BASE_DIR ]]; then
    relativePath=$(basename $PWD)
# else 
#   relativePath=$(python -c "import os.path; print os.path.relpath('$PWD', '$START_DIR')")
# fi
	
#  if [[ "$PWD" = "$HOME" ]]
#  then
#    relativePath="~"
#    if [[ "$PWD" = "$START_DIR" ]]
#    then
#      relativePath="≋"
#    fi
#  fi
#  if [[ $relativePath = '.' ]]
#  then
#    relativePath="≈"
#  fi
  if [[ $relativePath = $baseDir ]] 
  then
    relativePath=""
  fi
  if [[ $relativePath = "/" ]] 
  then
    relativePath=""
  fi
  prompt_segment 7 15 "$relativePath"
#  echo -n "%F{black}%K{7} $relativePath "
#  echo -n "%F{9}"
}

prompt_logo() {
  prompt_segment 9 gray ""
  echo -n "%K{9}%F{black} ⎪"
}

prompt_time() {
# prompt_segment 9 gray "%D{%H:%M:%S}"
  echo "%F{7}%D{%H:%M:%S}"
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
