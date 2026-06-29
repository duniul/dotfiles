#!/usr/bin/env bash

##############################################################################################################
### XCode Command Line Tools


if ! xcode-select --print-path &>/dev/null; then

  echo "XCode Command Line Tools not found, installing..."

  # Prompt user to install the XCode Command Line Tools
  xcode-select --install &>/dev/null

  # Wait until the XCode Command Line Tools are installed
  until xcode-select --print-path &>/dev/null; do
    sleep 5
  done

else 
  echo "XCode Command Line Tools found, continuing..."
fi
###
##############################################################################################################

##############################################################################################################
### homebrew, shells and global packages!

# install Homebrew if needed
if ! which brew &>/dev/null; then

  echo "Homebrew not found, installing..."

  # this scripts installs it the regular way by default (/usr/local):
  # shellcheck disable=SC2091
  sudo curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

else
  echo "Homebrew found, continuing..."
fi


echo "Installing packages and apps from the Brewfile..."
brew bundle --file ~/.Brewfile

echo "Adding bash and fish to /etc/shells..."
brewpath=$(brew --prefix)
bashpath="$brewpath/bin/bash"
fishpath="$brewpath/bin/fish"

sudo bash -c "echo $bashpath$'\n'$fishpath >> /etc/shells"

echo "Setting fish as default shell..."
chsh -s "$fishpath"

echo "Installing fisher packages..."
fish -c "fisher update"

echo "Installing better nanorc config..."
curl https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh

echo "Installing Node LTS via fnm..."
fnm install 24

echo "Installing global pnpm deps..."
pnpm -g install

echo "Done!"

### end of homebrew
##############################################################################################################
