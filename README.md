# kolezka-setup

Terminal setup with Zsh, Oh My Zsh, Starship (Tokyo Night), and modern CLI tools.

## What's included

- `.zshrc` — optimized Zsh config with Oh My Zsh plugins, aliases, and keybindings
- `starship.toml` — Tokyo Night single-line prompt (directory + git)
- `install.sh` — automated installer for everything

## Install on a new machine

```bash
git clone git@github.com:kolezka/kolezka-setup.git
cd kolezka-setup
./install.sh
```

Then open a new terminal.

## What the installer does

1. Installs **Homebrew** (macOS only, if missing)
2. Installs **Starship** prompt
3. Installs **Oh My Zsh** + plugins:
   - zsh-autosuggestions
   - zsh-syntax-highlighting
   - zsh-completions
   - zsh-autocomplete
4. Installs modern CLI tools: `eza`, `bat`, `fd`, `ripgrep`, `fzf`, `dust`, `bottom`
5. Symlinks `.zshrc` and `starship.toml` to the right locations
6. Creates `~/.zshrc.local` for machine-specific secrets and config

## Local config

Put API keys, tokens, and machine-specific settings in `~/.zshrc.local` — this file is sourced automatically and is **not** tracked in git.

```bash
# ~/.zshrc.local example
export FIGMA_TOKEN="your-token"
export GITHUB_TOKEN="your-token"
```
