
# Append custom_functions directory to fish_function_path to make fish autoload the functions from there.
# https://fishshell.com/docs/current/#autoloading-functions
set --append fish_function_path "/Users/daniel/.config/fish/custom_functions"

# Append bin directories to PATH
fish_add_path "$HOME/bin"

# Set specific brew and python bins for M1
if [ (uname -m) = arm64 ]
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
    fish_add_path $HOME/Library/Python/**/bin
end

# Append Rust Cargo to PATH
fish_add_path "$HOME/.cargo/bin"

# Load common dotfiles
for file in ~/{.exports,.aliases,.functions,.extras}
    test -e "$file" && source $file
end

# Load shell specific dotfiles
# To load settings that shouldn't be commited, use the extras files:
#   ~/.config/fish/extras-pre.sh: extras that should run BEFORE the other dotfiles (for setting PATH etc.)
#   ~/.config/fish/extras-post.sh: extras that should run AFTER the other dotfiles (to be able to use exports and functions)
for file in ~/.config/fish/{extras-pre,exports,aliases,extras-post}.fish
    test -e "$file" && source $file
end
set -e file

### Fish SPECIFICS ###
# These settings are unique for Fish, and do not need to be enabled for Bash

# ## fish.nvm defaults
# set --universal nvm_default_version "lts"
# set nvm_response (nvm use 2>&1) # use default version if available, redirect all output to stdout

# if string match -q -- "*Invalid version or missing*" $nvm_response
#     nvm use $nvm_default_version >/dev/null
# else if string match -q -- "*Node version not installed*" $nvm_response
#     nvm install
# end

### STOP FISH SPECIFICS ###

### START SHELL COMMONS ###
# These settings need to be configured in both .bash_profile and fish.config

# Set dircolors, using custom 'dircolors-fish' function
eval (dircolors-fish ~/.dircolors/duniul.dircolors)

## direnv (https://direnv.net/)
eval (direnv hook fish) # Enable direnv

### END SHELL COMMONS ###

# Easy navigation funcs that I don't want to create separate function files for
function ..
    cd ..
end
function ...
    cd ../..
end
function ....
    cd ../../..
end
function .....
    cd ../../../..
end

# Auto-added by `volta setup`
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH
