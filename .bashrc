#!/usr/bin/env bash

# Path to the bash it configuration
export BASH_IT="/usr/local/google/home/manukh/.bash_it"

export BASH_IT_THEME='bobby'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='irssi'


# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Load Bash It
source "$BASH_IT"/bash_it.sh

# custom aliases

o() {
    gedit $1
}

setting() {
    o ~/.bashrc
}

gitsetting() {
    o ~/.gitconfig
}

r() {
    exec bash
}

export PATH=$PATH:/usr/local/google/home/manukh/workspace/depot_tools

GOMA_DIR=${HOME}/workspace/goma

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

gomaStart() {
    ${GOMA_DIR}/goma_ctl.py ensure_start
}

cbuild() {
    cd ~/workspace/chromium/src
    ninja -C out/Default chrome
}

cgbuild() {
    cd ~/workspace/chromium/src
    ninja -C out/Default -j 1000 chrome
}

crun() {
    cd ~/workspace/chromium/src
    out/Default/chrome
}

cbr() {
    cgbuild && crun   
}

clip() {
    xclip -selection c
}

clion() {
    /opt/clion-2017.3/bin/clion.sh $1
}
