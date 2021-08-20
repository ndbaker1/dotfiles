#!/bin/sh

# START_GENERATED_VARS
REPO_URL="git@github.com:ndbaker1/conf.git"
# END_GENERATED_VARS

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

[ -d $HOME/.dotfiles.git ] || git clone --bare $REPO_URL $HOME/.dotfiles.git

dotfiles checkout
dotfiles config --local status.showUntrackedFiles no

echo "Completed."

