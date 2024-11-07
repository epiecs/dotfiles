# 
# Variables
# 

GNS3_SERVER="gns3-gregory.rijkelhq.local"
NOTESDIR="/Users/gregory/Desktop/Projects/obsidian-notes"
LABDIR="/Users/gregory/Desktop/Projects"
SERIAL_ADAPTER="/dev/tty.usbserial-AH06CZLR"

# 
# Checks and init
# 

# Set homebrew path if homebrew is installed
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

## BASH settings
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=2000
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Initial prompt
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# 
# Personal settings
# 

## command aliases

# Aliases can use sudo
alias sudo="sudo "

# Mac specific, map clip to pbcopy
if [ "$(uname)" == "Darwin" ]; then
    alias clip="pbcopy"
else
    alias clip="xclip"
fi

# Mac specific commands
# turns of indexing, removes indexes and restarts indexing
alias rebuildspotlight="sudo mdutil -a -i off; sudo rm -rf /.Spotlight* ; sudo mdutil -a -i on; sudo mdutil -E"

# Base aliases
alias ll="ls -lhF"
alias la="ls -alhF"
alias l='ls -CF'
alias du="du -sh"
alias free="free -h"
alias tree="tree -pug"
alias dd='dd status=progress'
alias ffs='sudo !!'

# Tmux aliases
alias tat='tmux attach'
alias tls='tmux ls'
alias tkill='tmux kill-server'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'

# Python aliases
alias activate='source .venv/bin/activate'
alias newvenv='python3 -m venv .venv'

alias tothelab="cd ${LABDIR}"
alias syncnotes="git -C ${NOTESDIR} pull; git -C ${NOTESDIR} add .; git -C ${NOTESDIR} status; git -C ${NOTESDIR} commit -am 'sync'; git -C ${NOTESDIR} push"

# # Aliases only if the tool is installed
# if [command -v bat 2>&1 >/dev/null]; then
#     alias cat="bat -pp"
# fi

# Serial connections
alias console="picocom ${SERIAL_ADAPTER}"

# quickly connect to lab device with lab <devname>
function lab() {
    PORT=$(curl -sX GET http://${GNS3_SERVER}/v2/projects | jq '.[] | select(.status=="opened") | .project_id' | \
    xargs -I PID curl -sX GET http://${GNS3_SERVER}/v2/projects/PID/nodes | jq --arg node $1 '.[] | select(.name==$node) | .console' )

    telnet ${GNS3_SERVER} $PORT
}

alias rackpower="while true; do curl -sX GET http://10.30.180.21/status | jq .meters[0].power; sleep 1; done | pipeplot --min 50 --max 250 --direction right"

## env vars
export EDITOR="/usr/bin/nano"
# for python packages installed with --user
export PATH="$PATH:~/.local/bin"
# disable ps1 change by python venv
export VIRTUAL_ENV_DISABLE_PROMPT=1
# ansible cant use cows
export ANSIBLE_NOCOWS=1
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# Disable mac zsh notification
export BASH_SILENCE_DEPRECATION_WARNING=1,

# 
# Prompt
# 

# colors
RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[33;1m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[01;96m\]"
WHITE="\[\033[0;39m\]"


#trim \w in PS1 to specific length

## functions
# get venv
get_virtualenv(){
    echo $VIRTUAL_ENV | sed -e 's/^.*\///' -e 's/-.*//'
}

get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Prompt vars
PROMPT_LINECOLOR="${WHITE}"
PROMPT_BRACKETCOLOR="${WHITE}"

#characters
PROMPT_START="\342\224\214"
PROMPT_START_NEWLINE="\342\224\224"
PROMPT_DIVIDER="\342\224\200"

PROMPT_DIRTRIM=2

build_prompt() {
    PS1="${RESET}"
    PS1+="${PROMPT_LINECOLOR}${PROMPT_START}"
    PS1+="${PROMPT_BRACKETCOLOR}[${WHITE}\u${YELLOW}@${BLUE}\h${PROMPT_BRACKETCOLOR}]"
    # PS1+="${PROMPT_LINECOLOR}${PROMPT_DIVIDER}"
    # PS1+="${PROMPT_BRACKETCOLOR}[${BLUE}\A${PROMPT_BRACKETCOLOR}]"
    PS1+="${PROMPT_LINECOLOR}${PROMPT_DIVIDER}"
    PS1+="${PROMPT_BRACKETCOLOR}[${GREEN}\w${PROMPT_BRACKETCOLOR}]"
    PS1+="\$(if [ \$(get_git_branch) ]; then echo '${PROMPT_LINECOLOR}${PROMPT_DIVIDER}${PROMPT_BRACKETCOLOR}[${YELLOW}'\$(get_git_branch)'${PROMPT_BRACKETCOLOR}]'; fi)"
    PS1+="\$(if [ \$(get_virtualenv) ]; then echo '${PROMPT_LINECOLOR}${PROMPT_DIVIDER}${PROMPT_BRACKETCOLOR}[${GREEN}'\$(get_virtualenv)'${PROMPT_BRACKETCOLOR}]'; fi)"
    PS1+="\n"
    PS1+="${PROMPT_LINECOLOR}${PROMPT_START_NEWLINE}"
    PS1+="${WHITE}>${NORMAL} "
    
}
# export PS1="${RESET}${RED}${PROMPT_START}[${WHITE}\u${YELLOW}@${BLUE}\h${RED}]${PROMPT_DIVIDER}[${BLUE}\A${RED}]${PROMPT_DIVIDER}[${GREEN}\w${RED}]\$(if [ \$(get_git_branch) ]; then echo '${PROMPT_DIVIDER}[${YELLOW}'\$(get_git_branch)'${RED}]'; fi)\n${RED}${PROMPT_START_NEWLINE}\$(if [ \$(get_virtualenv) ]; then echo '${GREEN} (venv:'\$(get_virtualenv)')'; fi) ${YELLOW}\$${NORMAL} "
# export PS1="${RESET}${PROMPT_LINECOLOR}${PROMPT_START}${PROMPT_USER}${PROMPT_DIVIDER}${PROMPT_DIRECTORY}${PROMPT_GIT}\n${PROMPT_LINECOLOR}${PROMPT_START_NEWLINE}${PROMPT_VENV} ${YELLOW}\$${NORMAL} "
# export PS1="${PROMPT_USER}${PROMPT_DIVIDER}${PROMPT_DIRECTORY}${PROMPT_GIT}\n${PROMPT_LINECOLOR}${PROMPT_START_NEWLINE}${PROMPT_VENV} ${YELLOW}\$${NORMAL} "
# export PS1=$(build_prompt)

PROMPT_COMMAND=build_prompt