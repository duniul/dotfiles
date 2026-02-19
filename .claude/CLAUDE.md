# Dotfiles - Bare Git Repo

These dotfiles are managed as a **bare Git repo** checked out to `$HOME`. The repo lives at `~/.dotfiles-git` and the
work tree is `~`. Interact with it using the `dot` alias, a wrapped `git` alias which only interacts with the dotfiles
repo (e.g. `dot status`, `dot add`, `dot commit`).

## Repo structure

### Shell configs (fish primary, bash for parity)

The user uses **fish** as their primary shell. Bash is maintained for feature parity where possible.

**Shared files** (sourced by both fish and bash):

- `.exports` - environment variables and path definitions (USER_BIN, PNPM_HOME, CARGO_BIN, etc.)
- `.aliases` - shared aliases (GNU coreutils wrappers, shortcuts, app aliases)

**Fish-specific:**

- `.config/fish/config.fish` - main fish config
- `.config/fish/aliases.fish` - fish-specific aliases and abbreviations
- `.config/fish/custom_functions/` - autoloaded fish functions (one function per file)
- `.config/fish/fish_plugins` - fisher plugin list
- `.config/fish/conf.d/` - fish conf.d scripts (auto-sourced)

**Bash-specific:**

- `.bashrc` - main bash config (sourced from `.bash_profile`)
- `.bash_profile` - just sources `.bashrc`
- `.config/bash/functions.sh` - bash functions (should mirror fish custom_functions)
- `.config/bash/prompt.sh` - bash prompt (fish uses pure-fish/pure)

**Sourcing order** (both shells follow this pattern):

1. Pre-load: `.extras-pre`, `.exports`, `.aliases` + shell-specific variants
2. PATH setup using variables from `.exports`
3. Post-load: `.extras` + shell-specific variants
4. Shell commons: dircolors, direnv, fnm

**Untracked extras files** (for sensitive/local config):

- `~/.extras-pre` / `~/.extras` - shared pre/post extras
- `~/.config/fish/extras-pre.fish` / `~/.config/fish/extras.fish`
- `~/.config/bash/extras-pre.sh` / `~/.config/bash/extras.sh`

### dotfiles setup and meta files

- `.dotfiles/setup.sh` - fresh install script (brew, fisher, pnpm, fnm)
- `.dotfiles/setup-dotfiles-git.sh` - bare repo bootstrap script
- `.dotfiles/migration.sh` - old machine migration helper

## git config

- `.gitconfig` - git config with aliases. Has a git-delta section at the bottom (intentionally separate
  `[core]`/`[diff]` sections). Commit signing via 1Password SSH.
- `.gitignore_global` - global gitignore

### Other configs

- `.macos` - macOS defaults script (interactive, run manually)
- `.Brewfile` - Homebrew manifest (packages, casks, Mac App Store apps)
- `.prettierrc` / `.editorconfig` - code formatting
- `.ncurc.json` - npm-check-updates config
- `.pnpm/global/5/package.json` - global pnpm packages
- `.config/ghostty/config` - terminal emulator config
- `.config/gh/config.yml` - GitHub CLI config

### Key conventions

- When adding a new function, add it in both `.config/fish/custom_functions/<name>.fish` and `.config/bash/functions.sh`
- When adding a new alias, add it to `.aliases` if it works in both shells, otherwise to the shell-specific alias file
- When adding a new export, add it to `.exports` if shared, otherwise to shell-specific extras
- GNU coreutils are aliased over macOS builtins (ls, cp, mv, rm, grep, find, cat).
  Originals available as `ocat`, `ofind`, etc.
