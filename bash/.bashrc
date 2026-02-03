# 
# Variables
# 

#GNS3_SERVER="gns3-gregory.rijkelhq.local"
GNS3_SERVER="10.10.50.50"
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

# Mac specific overrides
if [ "$(uname)" == "Darwin" ]; then
    alias clip="pbcopy"
    alias sed="gsed"
    export LC_CTYPE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
else
    alias clip="xclip"
    export LC_CTYPE=en_US.utf8
    export LC_ALL=en_US.utf8
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

# Handy aliases
alias newpass="pwgen -Bcn1 12"

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

function dockerbash() {
    local shell="${2:-/bin/bash}"
    docker exec -it $(docker ps | grep $1 | cut -c 1-4) $shell
}

function getcert() {
    echo | openssl s_client -showcerts -servername smtp.office365.com -connect smtp.office365.com:995 2>/dev/null | openssl x509 -inform pem -noout -text
}

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

draw_prompt_end()
{
    local TIME=$(date "+%T")
    printf "[${TIME}]"
}

draw_line()
{
    # function used to draw a line between commands
    local COLUMNS="$COLUMNS"
    local LINE=""
    
    while ((COLUMNS > 10)); do
        LINE+=$'\u2500'
        # LINE+="-"
        ((COLUMNS-=1))
    done

    # print line for the entire length and then use a carriage return to go back to the beginning of the line
    # Our prompt that we then generate overwrites this line where needed so that we always have a flexible length
    printf '%s\r' "${LINE}$(draw_prompt_end)"
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
    PS1="$(draw_line)"

    PS1+="${RESET}"
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

PROMPT_COMMAND=build_prompt