# General
alias l="ls -lah"
alias v="nvim"
alias t="tmux"

tproj() {
  local dir="${1:-$PWD}"
  local name

  if [ ! -d "$dir" ]; then
    echo "usage: tproj [path]"
    return 1
  fi

  name="${dir##*/}"
  name="${name#.}"
  name="${name//./-}"

  if tmux has-session -t "$name" 2>/dev/null; then
    if ! tmux list-windows -t "$name" -F '#W' | grep -q '^Cheatsheet$'; then
      tmux new-window -t "$name" -n "Cheatsheet" -c "$dir"
      tmux send-keys -t "$name":Cheatsheet "less -R ~/.dotfiles/KEYBINDS.md" C-m
    fi
    tmux attach -t "$name"
    return
  fi

  tmux new-session -d -s "$name" -c "$dir" -n " Editor"
  tmux send-keys -t "$name":1 "nvim ." C-m

  tmux new-window -t "$name":2 -n " Shell 1" -c "$dir"
  tmux new-window -t "$name":3 -n " Shell 2" -c "$dir"
  tmux new-window -t "$name":4 -n " Shell 3" -c "$dir"
  tmux new-window -t "$name":5 -n " OpenCode" -c "$dir"
  tmux send-keys -t "$name":5 "opencode" C-m
  tmux new-window -t "$name":6 -n " Cheatsheet" -c "$dir"
  tmux send-keys -t "$name":6 "less -R ~/.dotfiles/KEYBINDS.md" C-m

  tmux select-window -t "$name":1
  tmux attach -t "$name"
}

# Git
alias gs="git status"
alias gl="git log --oneline"
alias gp="git push"
alias gco="git checkout"
alias ga="git add"
alias gc="git commit -v"

# Docker / Node / Laravel shortcuts
alias dps="docker ps"
alias npmdev="npm run dev"
alias artisan="php artisan"
