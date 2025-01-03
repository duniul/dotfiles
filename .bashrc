# shellcheck shell=bash disable=SC1090,SC1091

###########
# SET PATHS

# Set specific brew and python bins for M1
if [[ $(uname -m) == 'arm64' ]]; then
  BREW_BIN="/opt/homebrew/bin"
  BREW_SBIN="/opt/homebrew/sbin"

  export PATH="$PATH:$BREW_BIN:$BREW_SBIN:/usr/local/bin:$USER_BIN"
fi

PYTHON_BINS=$(echo $HOME/Library/Python/*/bin | tr -s ' ' | tr ' ' '_')

# Append bin directories to PATH
export PATH="$PATH:$USER_BIN:$PNPM_HOME:$CARGO_BIN:$PYTHON_BINS"

# Source rustup/cargo env
. "$HOME/.cargo/env"

###############
# LOAD DOTFILES

# Load common dotfiles
for file in ~/{.extras-pre,.exports,.aliases,.extras}; do
  [ -r "$file" ] && source "$file"
done

# Load shell specific dotfiles
# To load settings that shouldn't be commited, use the extras files:
#   ~/.config/fish/extras-pre.sh: extras that should run BEFORE the other dotfiles (for setting PATH etc.)
#   ~/.config/fish/extras.sh: extras that should run AFTER the other dotfiles (to be able to use exports and functions)
for file in ~/.config/bash/{extras-pre,prompt,extras}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file

# Append custom functions file (equivalent to the custom_functions directory for Fish)
source "$HOME/.config/bash/functions.sh"

################
# BASH SPECIFICS
# These settings are unique for Bash, and do not need to be enabled for Fish

# Keep history up to date, across sessions, in realtime
# http://unix.stackexchange.com/a/48113
export HISTCONTROL="ignoredups"                        # no duplicate entries, but keep space-prefixed commands
export HISTSIZE=100000                                 # big big history (default is 500)
export HISTFILESIZE=$HISTSIZE                          # big big history
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear" # don't record some commands
shopt -s histappend                                    # append to history, don't overwrite it

# Enable some Bash features when possible:
# - cdspell: autocorrect typos in path names when using `cd`
# - dirspell: autocorrect on directory names to match a glob.
# - autocd:  e.g. `**/qux` will enter `./foo/bar/baz/qux`
# - globstart: recursive globbing, e.g. `echo **/*.txt`
# - nocaseglob: case-insensitive globbing (used in pathname expansion)
for option in cdspell dirspell autocd globstar nocaseglob; do
  shopt -s "$option" 2>/dev/null
done

################
# SHELL COMMONS
# These settings need to be configured in both .bash_profile and fish.config

# Dircolors
eval "$(gdircolors -b ~/.dircolors/duniul.dircolors)"

## direnv (https://direnv.net/)
eval "$(direnv hook bash)"

## fnm (https://github.com/Schniz/fnm)
eval "$(fnm env --use-on-cd)"

################################################
# UNCATEGORIZED OR AUTO-APPENDED BELOW THIS LINE
