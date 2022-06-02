# shellcheck shell=bash disable=SC1090,SC1091

# Append bin directories to PATH
USER_BIN="$HOME/bin"

# Set specific brew and python bins for M1
if [[ $(uname -m) == 'arm64' ]]; then
    BREW_BIN="/opt/homebrew/bin"
    BREW_SBIN="/opt/homebrew/sbin"
    PYTHON_BINS=$(echo $HOME/Library/Python/**/bin | tr -s ' ' | tr ' ' '_')
    export PATH="$PATH:$USER_BIN:$BREW_BIN:$BREW_SBIN:$PYTHON_BINS"
fi

# Load common dotfiles
for file in ~/{.exports,.aliases,.functions,.extras}; do
  test -e "$file" && source $file
done

# Load shell specific dotfiles
# To load settings that shouldn't be commited, use the extras files:
#   ~/.config/bash/extras-pre.sh: extras that should run BEFORE the other dotfiles (for setting PATH etc.)
#   ~/.config/bash/extras-post.sh: extras that should run AFTER the other dotfiles (to be able to use exports and functions)
for file in ~/.config/bash/{extras-pre,exports,functions,aliases,prompt,extras-post}.sh; do
  [ -r "$file" ] && source "$file"
done
unset file

### BASH SPECIFICS ###
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

## Tab completion

BREW_PREFIX=$(brew --prefix)

# Brew tab completion
if [ -r "$BREW_PREFIX/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$BREW_PREFIX/etc/bash_completion.d";
	source "$BREW_PREFIX/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &>/dev/null; then
  complete -o default -o nospace -F _git g
fi

### STOP BASH SPECIFICS ###

### START SHELL COMMONS ###
# These settings need to be configured in both .bash_profile and fish.config

# Dircolors
eval "$(gdircolors -b ~/.dircolors/duniul.dircolors)"

## thefuck (https://github.com/nvbn/thefuck)
eval "$(thefuck --alias)"

## direnv (https://direnv.net/)
eval "$(direnv hook bash)"

### END SHELL COMMONS ###

# Auto-added by `volta setup`
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
