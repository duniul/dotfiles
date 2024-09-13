###########
# SET PATHS

# Set specific brew bins for M1
if [ (uname -m) = arm64 ]
    fish_add_path /opt/homebrew/bin /opt/homebrew/sbin
end

# Append bin directories to PATH
fish_add_path "$USER_BIN" "$PNPM_HOME" "$CARGO_BIN" $HOME/Library/Python/*/bin

###############
# LOAD DOTFILES

# Load common dotfiles
for file in ~/{.extras-pre,.exports,.aliases,.extras}
    test -e "$file" && source $file
end

# Load shell specific dotfiles
# To load settings that shouldn't be commited, use the extras files:
#   ~/.config/fish/extras-pre.sh: extras that should run BEFORE the other dotfiles (for setting PATH etc.)
#   ~/.config/fish/extras.sh: extras that should run AFTER the other dotfiles (to be able to use exports and functions)
for file in ~/.config/fish/{extras-pre,exports,aliases,extras}.fish
    test -e "$file" && source $file
end
set -e file

# Append custom_functions directory to fish_function_path to make fish autoload the functions from there.
# https://fishshell.com/docs/current/#autoloading-functions
set --append fish_function_path "$HOME/.config/fish/custom_functions"

################
# FISH SPECIFICS
# These settings are unique for Fish, and do not need to be enabled for Bash

## fish keybindings

# Remove delete/exit hotkey
bind --erase "\cd" --all

# Remap Ctrl+D to delete history pager
bind --preset \cD history-pager-delete or backward-delete-char

# Remap clear to Ctrl-K (like VSCode has CMD+K)
bind --erase \cl --all
bind --user \v echo\ -n\ \(clear\ \|\ string\ replace\ \\e\\\[3J\ \"\"\)\;\ commandline\ -f\ repaint

## fzf (https://github.com/PatrickF1/fzf.fish)
# Remap fzf keybindings:
# - Search directory: Ctrl+F
# - Search git log: Ctrl+L
# - Search git status: Ctrl+S
# - Search history: Ctrl+H
# - Search processes: Ctrl+P
fzf_configure_bindings --directory=\cF --git_status=\cS --git_log=\f --history=\b --variables=\cV --processes=\cP

## pure-fish (https://github.com/pure-fish/pure)
set -g pure_color_prompt_on_success cyan # Different color for more contrast against red error prompts.
set -g pure_show_subsecond_command_duration true # Show subsecond (ex. 1.5s) in command duration.
set -g pure_threshold_command_duration 2 # Show command duration when above this value (seconds).

## fish-async-prompt (https://github.com/acomagu/fish-async-prompt)
set -g async_prompt_functions _pure_prompt_git # Async settings for pure-fish prompt (https://github.com/pure-fish/pure/wiki/Async-git-Prompt)

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true

################
# SHELL COMMONS
# These settings need to be configured in both .bash_profile and fish.config

# Set dircolors, using custom 'dircolors-fish' function
eval (dircolors-fish ~/.dircolors/duniul.dircolors)

## direnv (https://direnv.net/)
eval (direnv hook fish) # Enable direnv

## fnm (https://github.com/Schniz/fnm)
eval (fnm env --use-on-cd | source)

################################################
# UNCATEGORIZED OR AUTO-APPENDED BELOW THIS LINE
