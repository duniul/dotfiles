#!/usr/bin/env bash
# Fresh machine setup. Expects the dotfiles to already be checked out to $HOME
# (see setup-dotfiles-git.sh). Safe to re-run; every step is idempotent.

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
### Homebrew, packages and casks

if ! command -v brew &>/dev/null && [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
  echo "Homebrew not found, installing..."

  # Official installer (https://brew.sh). Installs to /opt/homebrew on Apple
  # Silicon and /usr/local on Intel, and asks for sudo itself when needed.
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew found, continuing..."
fi

# Make brew available in this script; the installer doesn't touch PATH.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "Installing packages and apps from the Brewfile..."
brew bundle --file ~/.Brewfile

##############################################################################################################
### Shells

brewpath=$(brew --prefix)
bashpath="$brewpath/bin/bash"
fishpath="$brewpath/bin/fish"

for shellpath in "$bashpath" "$fishpath"; do
  if ! grep -qx "$shellpath" /etc/shells; then
    echo "Adding $shellpath to /etc/shells..."
    echo "$shellpath" | sudo tee -a /etc/shells >/dev/null
  fi
done

if [ "$SHELL" != "$fishpath" ]; then
  echo "Setting fish as default shell..."
  chsh -s "$fishpath"
fi

echo "Installing fisher packages..."
fish -c "fisher update"

##############################################################################################################
### Node, pnpm and global packages

# Load shared exports (PNPM_HOME etc.)
# shellcheck disable=SC1090
source ~/.exports

echo "Installing Node LTS via fnm..."
eval "$(fnm env)"
fnm install --lts
fnm default lts-latest
fnm use lts-latest

echo "Enabling pnpm via corepack..."
export COREPACK_ENABLE_DOWNLOAD_PROMPT=0
corepack enable

echo "Installing global pnpm packages..."
export PATH="$PNPM_HOME/bin:$PATH"
# shellcheck disable=SC2046
pnpm add --global $(grep -v '^#' ~/.pnpm/global-packages.txt)

##############################################################################################################
### Misc

if [ ! -d ~/.nano ]; then
  echo "Installing better nanorc config..."
  curl -fsSL https://raw.githubusercontent.com/scopatz/nanorc/master/install.sh | sh
fi

##############################################################################################################
### Dock

# Restore the Dock last, so every app it pins has already been installed above.
# Snapshot with the `dock` shell function (`dock save`).
dockplist=~/.dotfiles/dock/com.apple.dock.plist
if [ -f "$dockplist" ]; then
  echo "Restoring Dock configuration..."
  defaults import com.apple.dock "$dockplist"
  killall Dock
fi

echo "Done!"
