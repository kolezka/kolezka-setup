# kolezka-setup

Terminal setup with Zsh, Oh My Zsh, Starship (Tokyo Night), and modern CLI tools. Works on macOS and Linux.

## Install on a new machine

```bash
git clone git@github.com:kolezka/kolezka-setup.git
cd kolezka-setup
./install.sh
```

Then open a new terminal.

## What's included

| File | Description |
|------|-------------|
| `.zshrc` | Optimized Zsh config with plugins, aliases, completions, and keybindings |
| `starship.toml` | Tokyo Night single-line prompt (directory + git) |
| `install.sh` | Cross-platform installer (macOS, Debian/Ubuntu, Arch, Fedora) |

## What the installer does

1. Installs **Homebrew** (macOS only, if missing)
2. Installs **Starship** prompt
3. Installs **Oh My Zsh** + plugins:
   - zsh-autosuggestions, zsh-syntax-highlighting, zsh-completions
   - zsh-autocomplete, zsh-history-substring-search, fzf-tab
4. Installs CLI tools: `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `dust`, `bottom`, `zoxide`, `thefuck`
5. Symlinks `.zshrc` and `starship.toml` to the right locations
6. Sets zsh as default shell (if not already)
7. Creates `~/.zshrc.local` for machine-specific secrets and config

## Features

**Prompt** — Starship with Tokyo Night theme, single-line: directory + git branch/status

**Plugins** — git, vi-mode, node/npm/yarn, docker, macos/brew/vscode, extract, sudo, dirhistory, colored-man-pages, copypath/copyfile, globalias, fzf-tab

**Navigation** — zoxide (smart `cd`), auto-ls on directory change, fzf for fuzzy finding, history substring search with arrow keys

**Aliases** — git (`g`, `gs`, `ga`, `gc`, `gp`, `glog`...), node/bun (`ni`, `nr`, `nrd`, `bi`, `br`, `brd`), modern CLI replacements (eza, bat, fd, rg, dust)

**Completions** — case-insensitive matching, fzf-tab with eza preview, autocomplete as you type

## Local config

Put API keys, tokens, and machine-specific settings in `~/.zshrc.local` — this file is sourced automatically and is **not** tracked in git.

```bash
# ~/.zshrc.local example
export FIGMA_TOKEN="your-token"
export GITHUB_TOKEN="your-token"
```
