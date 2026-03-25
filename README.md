# kolezka-setup

🚀 Modern terminal setup with Zsh, Oh My Zsh, Starship (Tokyo Night theme), and blazing-fast CLI tools. Optimized for macOS and Linux.

## 🚀 Quick Start

```bash
git clone git@github.com:kolezka/kolezka-setup.git
cd kolezka-setup
./install.sh
```

Then open a new terminal to enjoy your enhanced shell! ✨

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

### 🎨 **Prompt & Theme**
- **Starship** prompt with Tokyo Night theme
- Single-line format showing current directory + git branch/status
- Icons for file types and directories

### 🔌 **Plugins**
- **Git** — extensive git aliases and status in prompt
- **Vi-mode** — vim keybindings in terminal
- **Node/npm/yarn** — smart completions for Node.js ecosystem  
- **Docker** — docker command completions
- **macOS** — brew, vscode integrations (macOS only)
- **Utilities** — extract, sudo, dirhistory, colored-man-pages, copypath/copyfile, globalias
- **FZF-tab** — fuzzy completion with preview

### 🚀 **Navigation**
- **Zoxide** — smart `cd` replacement that learns your habits (aliased to `cd`)
- **Auto-ls** — automatically lists directory contents on cd
- **FZF** — fuzzy finder for files, directories, and history
- **History search** — search command history with arrow keys

### ⚡ **Modern CLI Replacements**
| Classic | Modern | Description |
|---------|--------|-------------|
| `ls` | `eza` | Better ls with icons, git status, tree view |
| `cat` | `bat` | Syntax highlighting, line numbers |
| `find` | `fd` | Faster, simpler syntax |
| `grep` | `ripgrep` | Much faster, respects .gitignore |
| `du` | `dust` | Visual disk usage |
| `top` | `bottom` | Better resource monitor |
| `cd` | `zoxide` | Smarter cd that learns |

### 🎯 **Aliases**
- **Git shortcuts** — `g` (git), `gs` (status), `ga` (add), `gc` (commit), `gp` (push), `gpl` (pull), `glog` (pretty log)
- **Node/Bun** — `ni` (npm install), `nr` (npm run), `nrd` (npm run dev), `bi` (bun install), `br` (bun run)
- **Navigation** — `..`, `...`, `....` for parent directories
- **Utilities** — `reload` (reload config), `zshrc` (edit config), `ip` (public IP), `path` (show PATH)

### 🔧 **Developer Tools**
- **Volta** — Node.js version management
- **Bun** — Fast JavaScript runtime (if installed)
- **Deno** — Secure TypeScript runtime (if installed)
- **TheFuck** — corrects previous console command

### ✨ **Completions**
- Case-insensitive matching
- FZF-tab with file preview (uses eza for directories, bat for files)
- Auto-suggestions as you type
- Smart completions for git, docker, npm, and more

## 🔐 Local Configuration

Put API keys, tokens, and machine-specific settings in `~/.zshrc.local` — this file is sourced automatically and is **not** tracked in git.

```bash
# ~/.zshrc.local example
export FIGMA_TOKEN="your-token"
export GITHUB_TOKEN="your-token"
export OPENAI_API_KEY="your-key"

# Machine-specific aliases
alias work="cd ~/Projects/work"
alias personal="cd ~/Projects/personal"
```

## 🐛 Troubleshooting

- **Slow startup?** — Check `~/.zshrc.local` for slow commands
- **Icons not showing?** — Install a Nerd Font from [nerdfonts.com](https://www.nerdfonts.com)
- **Command not found?** — Run `reload` or open a new terminal
- **Zoxide not working?** — It needs to learn your habits first. Use it for a few days!

## 📝 License

MIT
