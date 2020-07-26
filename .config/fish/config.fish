
# Append custom_functions directory to fish_function_path to make fish autoload the functions from there.
# https://fishshell.com/docs/current/#autoloading-functions
set --append fish_function_path "/Users/daniel/.config/fish/custom_functions"

# Load common dotfiles
for file in ~/{.exports,.aliases,.functions}
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

# Pisces (https://github.com/laughedelic/pisces)
set -x pisces_only_insert_at_eol 1 # only add pair symbol if at end of line

### STOP BASH SPECIFICS ###

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
