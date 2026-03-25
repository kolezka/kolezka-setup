# Add deno completions to search path
if [[ -d "$HOME/.zsh/completions" ]] && [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then 
  export FPATH="$HOME/.zsh/completions:$FPATH"
fi
# ── Performance ──────────────────────────────────────
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""
PROMPT=""

# ── Plugins (syntax-highlighting must be last) ────────
plugins=(
  git vi-mode
  node npm yarn docker
  macos brew vscode
  extract sudo dirhistory
  colored-man-pages
  copypath copyfile
  globalias
  fzf-tab
  zsh-autosuggestions
  zsh-completions
  zsh-autocomplete
  zsh-history-substring-search
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ── Starship ─────────────────────────────────────────
if command -v starship &>/dev/null; then
    eval "$(starship init zsh)"
fi


# ── History ──────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS

# ── Navigation ───────────────────────────────────────
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT

# ── Completions ──────────────────────────────────────
zstyle ':completion:*' complete-options true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'eza --icons --color=always $realpath 2>/dev/null || echo $realpath'
zstyle ':autocomplete:*' min-delay 0.1
zstyle ':autocomplete:*' min-input 1
zstyle ':autocomplete:list-choices:*' max-lines 10
zstyle ':autocomplete:*' widget-style menu-select
zstyle ':autocomplete:*' fzf-completion no
zmodload zsh/complist

# ── Autosuggestions ──────────────────────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#663399,standout"
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1
bindkey '^ ' autosuggest-accept

# ── Keybindings ──────────────────────────────────────
# Other navigation keys
bindkey '^[[1;5C' forward-word       # Ctrl+Right
bindkey '^[[1;5D' backward-word      # Ctrl+Left
bindkey '^[[3~' delete-char          # Delete
bindkey '^[[H' beginning-of-line     # Home
bindkey '^[[F' end-of-line           # End

# Use Ctrl+P/N for history search (doesn't conflict with arrow keys)
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# globalias: expand aliases on space
globalias() {
  [[ $LBUFFER =~ '[a-zA-Z0-9]+$' ]] && { zle _expand_alias; zle expand-word }
  zle self-insert
}
zle -N globalias
bindkey " " globalias
bindkey "^[[Z" magic-space
bindkey -M isearch " " magic-space

# ── Auto-ls on cd ────────────────────────────────────
AUTO_LS_COMMANDS=(ls git-status)
AUTO_LS_NEWLINE=false

auto_ls() {
  if command -v eza &> /dev/null; then
    eza --icons --git
  elif command -v exa &> /dev/null; then
    exa --icons --git
  else
    ls -la
  fi
}
chpwd_functions+=(auto_ls)

# ── Platform ─────────────────────────────────────────
case "$(uname -s)" in
  Darwin)
    export HOMEBREW_NO_ANALYTICS=1
    if [[ -d "/opt/homebrew" ]]; then
      export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    elif [[ -d "/usr/local" ]]; then
      export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
    fi
    ;;
  Linux)
    if command -v pacman &> /dev/null; then
      alias pacman='sudo pacman'
      alias yay='yay --sudoloop'
    fi
    ;;
esac

# ── SSH agent ────────────────────────────────────────
if [[ -z "${SSH_AUTH_SOCK:-}" ]] || ! ssh-add -l >/dev/null 2>&1; then
  eval "$(ssh-agent -s)" >/dev/null
fi

for key in "$HOME/.ssh/"*; do
  [[ -f "$key" ]] || continue
  [[ "$key" =~ \.(pub|config|known_hosts)$ ]] && continue
  [[ -f "$key.pub" ]] || continue
  alias "ssh-$(basename "$key")"="ssh-add '$key'"
done

# ── Environment ──────────────────────────────────────
export EDITOR='code --wait'
export VISUAL='code --wait'

# ── PATH ─────────────────────────────────────────────
export VOLTA_HOME="$HOME/.volta"
PATH="$VOLTA_HOME/bin:$PATH"

if [[ -d "$HOME/.local/bin" ]]; then PATH="$HOME/.local/bin:$PATH"; fi
if [[ -d "$HOME/bin" ]]; then PATH="$HOME/bin:$PATH"; fi
if command -v go &> /dev/null; then export GOPATH="$HOME/go"; PATH="$GOPATH/bin:$PATH"; fi
if [[ -d "$HOME/.cargo/bin" ]]; then PATH="$HOME/.cargo/bin:$PATH"; fi

export PATH

# ── FZF ──────────────────────────────────────────────
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --color=always {}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ── Aliases: general ─────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias h='history | tail -50'
alias j='jobs -l'
alias reload='source ~/.zshrc'
alias zshrc='$EDITOR ~/.zshrc'
alias ip='curl ifconfig.me'
alias ping='ping -c 5'
alias mkdir='mkdir -pv'
alias path='echo -e ${PATH//:/\\n}'
alias mount='mount | column -t'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# ── Aliases: git ─────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gca='git commit --amend'
alias gp='git push'
alias gpl='git pull --rebase'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias gds='git diff --staged'

# ── Aliases: node / bun ──────────────────────────────
alias ni='npm install'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias bi='bun install'
alias br='bun run'
alias brd='bun run dev'

# ── Aliases: modern CLI tools ────────────────────────
if command -v eza &> /dev/null; then
  alias ls='eza --icons --group-directories-first'
  alias ll='eza --icons --group-directories-first -la --git'
  alias la='eza --icons --group-directories-first -a'
  alias lt='eza --icons --tree --level=2'
  alias ./='eza --icons -la .'
  alias ../='eza --icons -la ..'
elif command -v exa &> /dev/null; then
  alias ls='exa --icons'
  alias ll='exa -la --icons'
  alias tree='exa --tree --icons'
  alias ./='exa --icons -la .'
  alias ../='exa --icons -la ..'
fi

if command -v bat &> /dev/null; then alias cat='bat --paging=never'; fi
export BAT_THEME="Catppuccin Mocha"

if command -v fd &> /dev/null; then alias find='fd'; fi
if command -v rg &> /dev/null; then alias grep='rg'; fi
if command -v dust &> /dev/null; then alias du='dust'; fi
if command -v bottom &> /dev/null; then alias top='btm'; fi

# ── thefuck ──────────────────────────────────────────
if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
  alias f='fuck'
fi

# ── NVM ──────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ── Functions ────────────────────────────────────────
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2) tar xjf $1   ;; *.tar.gz) tar xzf $1    ;;
      *.bz2)     bunzip2 $1   ;; *.rar)    unrar e $1     ;;
      *.gz)      gunzip $1    ;; *.tar)    tar xf $1      ;;
      *.tbz2)    tar xjf $1   ;; *.tgz)    tar xzf $1    ;;
      *.zip)     unzip $1     ;; *.Z)      uncompress $1  ;;
      *.7z)      7z x $1      ;; *)        echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

mkcd() { mkdir -p "$1" && cd "$1" }

# ── Local config (secrets, machine-specific) ─────────
[ -f ~/.zsh_aliases ] && source ~/.zsh_aliases
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Deno
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ── Zoxide (must be at the end) ─────────────────────
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
fi
