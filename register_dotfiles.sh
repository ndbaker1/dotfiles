#!/usr/bin/env sh

REPO_URL="https://github.com/ndbaker1/conf.git"

[ -d $HOME/.dotfiles.git ] || git clone --bare $REPO_URL $HOME/.dotfiles.git
alias dotfiles="git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"

dotfiles checkout && \
dotfiles config --local status.showUntrackedFiles no && \
echo "registered alias 'dotfiles'"

