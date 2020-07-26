#!/usr/bin/env bash

DOTFILES_GIT_DIR="$HOME/.dotfiles-git"

if [ -d "$DOTFILES_GIT_DIR" ]; then
  echo "$DOTFILES_GIT_DIR already exists. Please remove it and rerun this script."
  exit 1
fi

git clone --bare https://github.com/duniul/dotfiles.git $DOTFILES_GIT_DIR

# don't show untracked files
git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME config --local status.showUntrackedFiles no
# checkout bare git repo contents
git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME checkout
checkoutExitCode=$?

postCheckoutInfo="https://github.com/duniul/dotfiles for instructions on what to do next."

# check exit code of checkout
# shellcheck disable=SC2181
if [ $checkoutExitCode -eq 0 ]; then
  echo
  echo "dotfiles checked out correctly and have been set up in $DOTFILES_GIT_DIR."
  echo "See $postCheckoutInfo"
else
  echo
  echo "dotfiles checkout failed! Please fix the issues listed above and redo the checkout with this command: "
  echo "git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME checkout"
  echo
  echo "When the checkout has succeeded, see $postCheckoutInfo"
fi
