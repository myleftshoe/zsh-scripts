$SHELL --version

# Set code page to Unicode UTF-8
#chcp 65001

#********************* MY SETTINGS ************************
export DEV="/mnt/x"
alias dev="cd $DEV"
alias react="cd $DEV/react"
alias sysinfo="clear; neofetch"
alias gs="git status"
SCRIPTS="$HOME/scripts"
alias scripts="cd $SCRIPTS"


function preexec() {
  timer=$(($(date +%s%N)/1000000))
}

function precmd() {
  if [ $timer ]; then
    now=$(($(date +%s%N)/1000000))
    elapsed=$(($now-$timer))

#   export RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
    unset timer
  fi
}

#replace ls to not show windows hidden files
ls() {
  if test "${PWD##/mnt/}" != "${PWD}"; then
     cmd.exe /D /A /C 'dir /B /AH 2> nul' \
       | sed 's/^/-I/' | tr -d '\r' | tr '\n' '\0' \
       | xargs -0 /bin/ls "$@"
  else
    /bin/ls "$@"
fi
}

# Set Start Dir - command prompt will show paths relative to this
set~~() {
  _HOME=$PWD
  echo
  echo Start folder set to $_HOME
  echo
}

alias get~~='echo "\n $_HOME"'

# ~ goes to home folder, ~~ will now go to $_HOME
alias ~~='cd $_HOME'
alias go~~='cd $_HOME'

# z - for jumping around folders
source ~/z.sh

export PATH=$PATH:$HOME/Library/Python/2.7/bin

set~~

#[ "$PWD" = "$HOME" ] && neofetch

#********************* OH-MY-ZSH SETTINGS ************************

ZSH_THEME="/../../.current"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  node
  npm
  vscode
  extract
  zsh-syntax-highlighting
  zsh-autosuggestions
  command-not-found
#  vi-mode
)

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

source $ZSH/oh-my-zsh.sh

#Change ls colours
LS_COLORS="ow=01;36;40" && export LS_COLORS

#make cd use the ls colours
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -Uz compinit
compinit

source ~/.setup_extraterm_zsh.zsh
