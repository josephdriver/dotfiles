# === PATHs ===
source ~/.dotfiles/zsh/path.zsh

# Ensure tmux works under Ghostty
if [ "$TERM" = "xterm-ghostty" ]; then
  export TERM=xterm-256color
fi

# === Aliases ===
source ~/.dotfiles/zsh/aliases.zsh

# plugin manager
source "$HOME/.zinit/bin/zinit.zsh"

# plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# === Starship prompt ===
eval "$(starship init zsh)"

# === History settings ===
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt append_history
setopt autocd
setopt correct
setopt extendedglob

# === Optional utilities ===
autoload -Uz compinit && compinit

# opencode
export PATH=/Users/joedriver/.opencode/bin:$PATH
