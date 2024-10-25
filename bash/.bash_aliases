## command aliases

GNS3_SERVER="gns3-gregory.rijkelhq.local"
NOTESDIR="/Users/gregory/Desktop/Projects/obsidian-notes"

# Aliases can use sudo
alias sudo="sudo "

# Mac specific settings
if [ "$(uname)" == "Darwin" ]; then
    alias clip="pbcopy"
fi

alias ll="ls -lhF"
alias la="ls -alhF"
alias l='ls -CF'
alias du="du -sh"
alias free="free -h"
alias tree="tree -pug"
alias dd='dd status=progress'

alias gs='git status'

alias console="picocom /dev/tty.usbserial-AH06CZLR"

alias ffs='sudo !!'

alias activate='source .venv/bin/activate'
alias newvenv='python3 -m venv .venv'

alias tothelab="cd /Users/gregory/Desktop/Projects"
alias syncnotes="git -C ${NOTESDIR} pull; git -C ${NOTESDIR} add .; git -C ${NOTESDIR} status; git -C ${NOTESDIR} commit -am 'sync'; git -C ${NOTESDIR} push"

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
export ANSIBLE_NOCOWS=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# For mac zsh notification
export BASH_SILENCE_DEPRECATION_WARNING=1,
# colors
RESET="\[\017\]"
NORMAL="\[\033[0m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[33;1m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[01;96m\]"
WHITE="\[\033[0;39m\]"

#characters
PROMPT_START="\342\224\214\342\224\200"
PROMPT_START_NEWLINE="\342\224\224\342\224\200\342\225\274"
PROMPT_DIVIDER="\342\224\200"

#trim \w in PS1 to specific length
PROMPT_DIRTRIM=3

## functions
# get venv
get_virtualenv(){
    echo $VIRTUAL_ENV | sed -e 's/^.*\///' -e 's/-.*//'
}

get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

export PS1="${RESET}${RED}${PROMPT_START}[${WHITE}\u${YELLOW}@${BLUE}\h${RED}]${PROMPT_DIVIDER}[${BLUE}\A${RED}]${PROMPT_DIVIDER}[${GREEN}\w${RED}]\$(if [ \$(get_git_branch) ]; then echo '${PROMPT_DIVIDER}[${YELLOW}'\$(get_git_branch)'${RED}]'; fi)\n${RED}${PROMPT_START_NEWLINE}\$(if [ \$(get_virtualenv) ]; then echo '${GREEN} (venv:'\$(get_virtualenv)')'; fi) ${YELLOW}\$${NORMAL} "
