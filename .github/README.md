<p align="center">
  <img alt="doot doot" title="Made by Hot Paper Comics" src="https://user-images.githubusercontent.com/11836617/146030667-fdeefa54-b624-4fb8-bbee-3354b874356e.png" height="260" align="center" />
</p>

# duniul's dootfiles

These are my dotfiles, they're pretty cool but also pretty basic. I prefer that they are easy to set up and understand over being super cool with tons of options that I never remember. I also don't use vim.

**Bare Git repo**  
The dotfiles are managed using a `bare` Git repo, [see this popular guide](https://www.atlassian.com/git/tutorials/dotfiles) for an idea of how it works. This setup differs a bit from the one in the guide though.

**Features**  
In short, this is what is included:

- `bash` and `fish` 🐟 stuff
  - configs with [exports](../.exports), [aliases](../.aliases), functions ([bash](../.config/bash/functions)/[fish](../.config/fish/custom_functions)), [abbreviations](../.config/fish/aliases) etc.
  - nice [`fisher`](https://github.com/jorgebucaran/fisher) packages
  - I use `fish` 95% of the time, but I like to keep corresponding exports, functions and aliases available in `bash` as well
- `brew` packages and casks
- `git` config with aliases and defaults
- `yarn` global packages
- macOS defaults

## Installation

#### 1) Clone to a bare Git repo <small>([`.dotfiles/setup-dotfiles-git.sh`](../.dotfiles/setup-dotfiles-git.sh))</small>

To automatically set up the bare Git repo and checkout the dotfiles, run:

```sh
curl -fsSL "https://raw.githubusercontent.com/duniul/dotfiles/main/.dotfiles/setup-dotfiles-git.sh" | bash
```

- If you don't feel like curling the script, you can [have a look at it yourself](.dotfiles/setup-dotfiles-git.sh) and run the steps manually.
- If the script fails, e.g. because of conflicting files, clear up the issues and either run the script again or follow the instructions in the command.

#### 2) Run the setup script <small>([`.dotfiles/setup.sh`](../.dotfiles/setup.sh))</small>

```sh
bash "~/.dotfiles/setup.sh"
```

- Installs Homebrew + packages and casks
- Installs Fisher + packages
- Installs Yarn + global packages
- Sets `$PATH`

#### 3) Set sensible macOS settings <small>([`.macos`](../.macos))</small>

```sh
bash "~/.macos"
```

This script configures _a lot_ of stuff on your mac, so have a quick look it before running it if you're not familiar with it.
If you're confused about what the different commands do, see [this reference guide](https://github.com/kevinSuttle/macOS-Defaults/blob/master/REFERENCE.md).

## Credits

- The dootin' skeleton image in this readme was made by [Hot Paper Comics](https://twitter.com/HotPaperComics), specifically [this reddit post](https://www.reddit.com/r/comics/comments/7xpt56/doot_dot_dot_dooot/).
- Many parts of this repo were inspired by other dotfile setups:
  - [paulirish/dotfiles](https://github.com/paulirish/dotfiles)
  - [rkalis/dotfiles](https://github.com/rkalis/dotfiles)
  - [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
