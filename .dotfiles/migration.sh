#!/usr/bin/env bash

migrationDir="$HOME/migration"
npmFile="npm-global-list.txt"
yarnFile="yarn-global-list.txt"

echo
echo "Prepping for migration!"
echo "Files will be copied to $migrationDir"
echo

echo "$(tput setaf 3)- Setting up $migrationDir$(tput sgr0)"
mkdir -p $migrationDir/_root/Library/Preferences/SystemConfiguration/
mkdir -p $migrationDir/.config/fish/
mkdir -p $migrationDir/.config/bash/
mkdir -p $migrationDir/Library/"Application Support"/
mkdir -p $migrationDir/Library/"Application Support"/Google/Chrome/Default
mkdir -p $migrationDir/Library/Preferences/


echo "$(tput setaf 3)- Saving Brewfile$(tput sgr0)"
brew bundle dump --file "$migrationDir/Brewfile" --force &>/dev/null

echo "$(tput setaf 3)- Saving a list of global NPM packages to $npmFile$(tput sgr0)"
npm list -g --depth=0 >$migrationDir/$npmFile

echo "$(tput setaf 3)- Saving a list of global Yarn packages to $yarnFile$(tput sgr0)"
yarn global list --depth=0 >$migrationDir/$yarnFile

echo "$(tput setaf 3)- Copying dotfiles not included in dotfiles repo$(tput sgr0)"
cp -Rp \
  ~/.extra* \
  ~/.config/bash/extra* \
  ~/.config/fish/extra* \
  ~/.aws \
  ~/.bash_history \
  ~/.gitconfig.local \
  ~/.gnupg \
  ~/.nano \
  ~/.nanorc \
  ~/.netrc \
  ~/.ssh \
  ~/.z \
  $migrationDir 2>/dev/null

echo "$(tput setaf 3)- Copying ~/Desktop, ~/Documents, ~/Pictures, ~/Services and ~/Fonts$(tput sgr0)"
cp -Rp ~/Desktop ~/Documents ~/Pictures ~/Services ~/Fonts $migrationDir/ 2>/dev/null

echo "$(tput setaf 3)- Copying VS Code settings$(tput sgr0)"
osascript -e 'quit app "Visual Studio Code"' &>/dev/null
cp -Rp ~/Library/"Application Support/Code" $migrationDir/Library/"Application Support"/ 2>/dev/null

echo "$(tput setaf 3)- Copying Sublime settings$(tput sgr0)"
osascript -e 'quit app "Sublime Text"' &>/dev/null
cp -Rp ~/Library/"Application Support/Sublime Text 3" $migrationDir/Library/"Application Support"/ 2>/dev/null

echo "$(tput setaf 3)- Copying Chrome extensions$(tput sgr0)"
osascript -e 'quit app "Google Chrome"' &>/dev/null
mkdir -p $migrationDir/Library/Google/Chrome/
cp -Rp ~/Library/"Application Support"/Google/Chrome/Default/Extensions $migrationDir/Library/Google/Chrome/Default/

echo "$(tput setaf 3)- Copying WiFi config$(tput sgr0)"
cp -Rp /Library/Preferences/SystemConfiguration/com.apple.airport.preferences.plist $migrationDir/_root/Library/Preferences/SystemConfiguration/

echo
echo "$(tput setaf 2)Done! Also consider: unpushed Git branches, new dotfiles, hidden files, downloads etc.$(tput sgr0)"
exit 0
