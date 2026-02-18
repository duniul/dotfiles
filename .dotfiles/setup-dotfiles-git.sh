#!/usr/bin/env bash
# shellcheck disable=SC2016

DOTFILES_GIT_DIR="$HOME/.dotfiles-git"

##############################################################################################################
### XCode Command Line Tools

if ! xcode-select --print-path &>/dev/null; then

  # Prompt user to install the XCode Command Line Tools
  xcode-select --install &>/dev/null

  # Wait until the XCode Command Line Tools are installed
  until xcode-select --print-path &>/dev/null; do
    sleep 5
  done

fi
###
##############################################################################################################

if [ -d "$DOTFILES_GIT_DIR" ]; then
  echo "$DOTFILES_GIT_DIR already exists. Please remove it and rerun this script."
  exit 1
fi

git clone --bare https://github.com/duniul/dotfiles.git "$DOTFILES_GIT_DIR"

dot="/usr/bin/git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME"

# set fetch and branch refs
$dot config --local remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
$dot config --local branch.main.remote "origin"
$dot config --local branch.main.merge "refs/heads/main"

# set author
$dot config --local user.name "Daniel Grefberg"
$dot config --local user.email "hello@danielgrefberg.com"

# don't show untracked files
$dot config --local status.showUntrackedFiles no

# checkout bare git repo contents
$dot checkout
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
