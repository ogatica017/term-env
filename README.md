# term-env

Portable personal terminal environment for macOS.

## Goals

- clone the repo
- run one setup script
- get a reproducible zsh-based terminal environment
- keep private/work-specific config out of the public repo
- make theme support optional

## What it manages

- `~/.zshrc`
- `~/.zprofile`
- optional `~/.p10k.zsh`
- local private overrides in `~/.term-env-local.zsh`

## What it installs

Via Homebrew:

- `diff-so-fancy`
- `fzf`
- `ripgrep`
- `tree`
- `zsh-autosuggestions`
- `zsh-completions`
- `zsh-syntax-highlighting`
- `powerlevel10k`
- `font-meslo-lg-nerd-font`

## Install

```bash
git clone https://github.com/ogatica017/term-env.git ~/term-env
cd ~/term-env
./setup.sh
```

## Safety model

`setup.sh` installs packages and symlinks managed dotfiles into your home directory.

Before replacing any managed dotfiles, it snapshots existing shell files into a timestamped folder under:

```bash
~/.term-env-backups/
```

Backed up if present:
- `~/.zshrc`
- `~/.zprofile`
- `~/.zshenv`
- `~/.p10k.zsh`

Managed by symlink:
- `~/.zshrc`
- `~/.zprofile`
- `~/.p10k.zsh` if you do not already have one

`~/.zshenv` is backed up defensively but is not managed by v1.

## Private / machine-specific config

Do **not** put secrets, work aliases, or machine-specific paths in the repo.

Put them in:

```bash
~/.term-env-local.zsh
```

This file is loaded last so local overrides win.

## Theme behavior

Powerlevel10k is optional.

Shell startup will:
- load `~/.p10k.zsh` if it exists
- skip theme setup if it does not
- skip theme setup if `TERM_ENV_DISABLE_THEME=1`

To disable theme loading:

```bash
export TERM_ENV_DISABLE_THEME=1
```

## Font note

Powerlevel10k prompt icons require a Nerd Font. This repo installs:

- `MesloLGS Nerd Font`

In iTerm2, set your profile font to:

- `MesloLGS NF`

If the prompt shows unresolved glyphs or weird boxes, the shell config is probably fine and the terminal font is the problem.

## Notes

- v1 is macOS-first
- v1 uses `oh-my-zsh`
- setup is meant to be rerunnable, but it is a bootstrap/install script — not something you run for every new shell
