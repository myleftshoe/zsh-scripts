# vim:ft=zsh ts=2 sw=2 sts=2

START_DIR=$PWD
START_BASE_DIR=$(echo "$START_DIR" | cut -d "/" -f2)
CURRENT_BG='NONE'

prompt_segment() {
  local bg fg
  fg="%F{$2}"
  bg="%b%K{$1}"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " $bg%F{$CURRENT_BG}$fg "
  else
    echo -n "$bg$fg "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  echo -n " %k%F{$CURRENT_BG}%f"
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
    else
      prompt_segment green black
    fi
    echo -n "${ref/refs\/heads\// }$dirty"
  fi
}

prompt_dir() {
#  prompt_segment blue 5 '%~'
  local relativePath baseDir
  baseDir=$(echo "$PWD" | cut -d "/" -f2)
  if [[ $baseDir != $START_BASE_DIR ]]; then
    relativePath=$PWD
  else 
    relativePath=$(python -c "import os.path; print os.path.relpath('$PWD', '$START_DIR')")
  fi
	
  if [[ $relativePath = "$HOME" ]]
  then
     relativePath="~"
  elif [[ $relativePath = '.' ]]
  then
    relativePath="≈"
  fi
  if [[ "$PWD" = "$START_DIR" ]]
  then
    relativePath="≋"
  fi
  prompt_segment 9 15 "$relativePath"
}

prompt_logo() {
  prompt_segment white 9 ""
}

prompt_time() {
  prompt_segment white black "%D{%H:%M:%S}"
}

## Main prompt
build_prompt() {
  echo #insert blank line before each prompt
  prompt_logo
  prompt_time
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='$(build_prompt) '
