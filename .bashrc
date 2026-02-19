# shellcheck shell=bash disable=SC1090,SC1091

# Load dotfiles that should run BEFORE the other dotfiles (for setting PATH etc.)
for file in ~/.{extras-pre,exports,aliases}.sh ~/.config/bash/{extras-pre,exports,aliases}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file

#
# SET PATHS
#
usr_local_bin="/usr/local/bin"
python_bins=$(echo "$HOME"/Library/Python/*/bin | tr -s ' ' | tr ' ' ':')
path_extras="$USER_BIN:$PNPM_HOME:$CARGO_BIN:$python_bins:$usr_local_bin"

if [[ $(uname -m) == 'arm64' ]]; then
  # Set extra brew bins for M1
  path_extras="$path_extras:/opt/homebrew/bin:/opt/homebrew/sbin"
fi

# Prepend bin directories to PATH
export PATH="$path_extras:$PATH"

# Load dotfiles that should run AFTER the other dotfiles
for file in ~/extras.sh ~/.config/bash/{prompt,extras}.sh; do
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
# - globstar: recursive globbing, e.g. `echo **/*.txt`
# - nocaseglob: case-insensitive globbing (used in pathname expansion)
for option in cdspell dirspell autocd globstar nocaseglob; do
  shopt -s "$option" 2>/dev/null
done

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true

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
