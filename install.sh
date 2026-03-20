#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

info()  { printf "\033[1;34m[INFO]\033[0m  %s\n" "$1"; }
ok()    { printf "\033[1;32m[OK]\033[0m    %s\n" "$1"; }
warn()  { printf "\033[1;33m[WARN]\033[0m  %s\n" "$1"; }
error() { printf "\033[1;31m[ERROR]\033[0m %s\n" "$1"; exit 1; }

# ── Package manager detection ────────────────────────
install_pkg() {
    local pkg="$1"
    if command -v brew &>/dev/null; then
        brew install "$pkg"
    elif command -v apt-get &>/dev/null; then
        sudo apt-get install -y "$pkg"
    elif command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm "$pkg"
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y "$pkg"
    else
        warn "No supported package manager found. Install '$pkg' manually."
        return 1
    fi
}

install_if_missing() {
    local cmd="$1"
    local pkg="${2:-$1}"
    if ! command -v "$cmd" &>/dev/null; then
        info "Installing $pkg..."
        install_pkg "$pkg"
        ok "$pkg installed"
    else
        ok "$cmd already installed"
    fi
}

# ── Prerequisites ────────────────────────────────────
install_if_missing git git
install_if_missing curl curl
install_if_missing zsh zsh

# ── Homebrew (macOS) ─────────────────────────────────
if [[ "$OS" == "Darwin" ]]; then
    if ! command -v brew &>/dev/null; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        [[ -d "/opt/homebrew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
        ok "Homebrew installed"
    else
        ok "Homebrew already installed"
    fi
fi

# ── Starship ─────────────────────────────────────────
if ! command -v starship &>/dev/null; then
    info "Installing Starship..."
    if command -v brew &>/dev/null; then
        brew install starship
    else
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
    ok "Starship installed"
else
    ok "Starship already installed"
fi

# ── Oh My Zsh ────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Installing Oh My Zsh..."
    RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    ok "Oh My Zsh installed"
else
    ok "Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# ── Zsh plugins ──────────────────────────────────────
declare -A PLUGINS=(
    [zsh-autosuggestions]="https://github.com/zsh-users/zsh-autosuggestions"
    [zsh-syntax-highlighting]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    [zsh-completions]="https://github.com/zsh-users/zsh-completions"
    [zsh-autocomplete]="https://github.com/marlonrichert/zsh-autocomplete.git"
    [zsh-history-substring-search]="https://github.com/zsh-users/zsh-history-substring-search.git"
    [fzf-tab]="https://github.com/Aloxaf/fzf-tab.git"
)

for plugin in "${!PLUGINS[@]}"; do
    if [[ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
        info "Installing plugin: $plugin"
        git clone --depth 1 "${PLUGINS[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin" >/dev/null 2>&1
        ok "$plugin installed"
    else
        ok "$plugin already installed"
    fi
done

# ── Modern CLI tools ─────────────────────────────────
# Map: command -> brew pkg : apt pkg : pacman pkg
declare -A TOOL_MAP=(
    [eza]="eza:eza:eza"
    [bat]="bat:bat:bat"
    [fd]="fd:fd-find:fd"
    [rg]="ripgrep:ripgrep:ripgrep"
    [fzf]="fzf:fzf:fzf"
    [dust]="dust:du-dust:dust"
    [btm]="bottom:bottom:bottom"
    [zoxide]="zoxide:zoxide:zoxide"
    [thefuck]="thefuck:thefuck:thefuck"
)

for cmd in "${!TOOL_MAP[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
        IFS=':' read -r brew_pkg apt_pkg pacman_pkg <<< "${TOOL_MAP[$cmd]}"
        info "Installing $cmd..."
        if command -v brew &>/dev/null; then
            brew install "$brew_pkg" 2>/dev/null || true
        elif command -v apt-get &>/dev/null; then
            sudo apt-get install -y "$apt_pkg" 2>/dev/null || true
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm "$pacman_pkg" 2>/dev/null || true
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y "$brew_pkg" 2>/dev/null || true
        else
            warn "Cannot install $cmd — no supported package manager"
            continue
        fi
        ok "$cmd installed"
    else
        ok "$cmd already installed"
    fi
done

# ── Symlink dotfiles ─────────────────────────────────
backup_and_link() {
    local src="$1"
    local dst="$2"
    if [[ -f "$dst" && ! -L "$dst" ]]; then
        warn "Backing up existing $dst -> ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi
    ln -sf "$src" "$dst"
    ok "Linked $(basename "$src") -> $dst"
}

backup_and_link "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.config"
backup_and_link "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"

# ── Create local config ─────────────────────────────
if [[ ! -f "$HOME/.zshrc.local" ]]; then
    cat > "$HOME/.zshrc.local" << 'EOF'
# Machine-specific configuration
# Put secrets, API keys, and local overrides here.
# This file is NOT tracked in git.
#
# Example:
# export FIGMA_TOKEN="your-token-here"
# export GITHUB_TOKEN="your-token-here"
EOF
    ok "Created ~/.zshrc.local for your secrets and local config"
else
    ok "~/.zshrc.local already exists"
fi

# ── Set default shell to zsh ─────────────────────────
if [[ "$SHELL" != *"zsh"* ]]; then
    ZSH_PATH="$(command -v zsh)"
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        info "Adding zsh to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi
    info "Changing default shell to zsh..."
    chsh -s "$ZSH_PATH"
    ok "Default shell set to zsh"
else
    ok "Default shell is already zsh"
fi

echo ""
info "Installation complete! Open a new terminal or run: exec zsh"
