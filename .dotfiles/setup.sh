#!/usr/bin/env bash

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

##############################################################################################################
### homebrew, shells and global packages!

# install Homebrew if needed
if ! which brew &>/dev/null; then
  # If your machine has /usr/local locked down, you can do this to place everything in ~/.homebrew:
  #   mkdir $HOME/.homebrew && curl -L https://github.com/mxcl/homebrew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew
  #   export PATH=$HOME/.homebrew/bin:$HOME/.homebrew/sbin:$PATH

  # this scripts installs it the regular way by default (/usr/local):
  # shellcheck disable=SC2091
  $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)
fi

# install packages and apps from the Brewfile
brew bundle --file ~/.Brewfile

### setup latest bash and fish
brewpath=$(brew --prefix)
bashpath="$brewpath/bin/bash"
fishpath="$brewpath/bin/fish"

# add bash (installed by homebrew) to list of shells
sudo bash -c "echo $bashpath >> /etc/shells"

# set fish as default shell for current user
chsh -s $fishpath

# install fisher packages
fish -c "fisher"

# install global yarn packages, for some reason there's not proper install command
yarn global upgrade

# install Settings Sync extension for VS Code, which will download settings and extensions on its own
code --install-extension "shan.code-settings-sync"

# install better nanorc config (https://github.com/scopatz/nanorc)
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

### end of homebrew
##############################################################################################################

##############################################################################################################
### extra stuff

# hide README.md from dotfiles
chflags hidden ~/README.md

### end of extra stuff
##############################################################################################################
