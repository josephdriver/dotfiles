#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Symlinking zsh + Starship dotfiles..."

mkdir -p ~/.config
mkdir -p ~/.config/nvim/lua
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/ghostty
mkdir -p ~/.config/opencode

# Install zinit if not installed
if [ ! -d "$HOME/.zinit/bin" ]; then
  git clone https://github.com/zdharma-continuum/zinit.git ~/.zinit/bin
fi

# Install TPM (Tmux Plugin Manager) if not installed
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

ln -sf "$SCRIPT_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$SCRIPT_DIR/zsh/aliases.zsh" ~/.aliases.zsh
ln -sf "$SCRIPT_DIR/zsh/path.zsh" ~/.path.zsh
ln -sf "$SCRIPT_DIR/starship.toml" ~/.config/starship.toml
ln -sf "$SCRIPT_DIR/nvim/lua/custom" ~/.config/nvim/lua/custom
ln -sf "$SCRIPT_DIR/nvim/lazyvim.json" ~/.config/nvim/lazyvim.json
ln -sf "$SCRIPT_DIR/tmux/.tmux.conf" ~/.tmux.conf
ln -sf "$SCRIPT_DIR/ghostty/config" ~/.config/ghostty/config
ln -sf "$SCRIPT_DIR/opencode/agents" ~/.config/opencode/agents
ln -sf "$SCRIPT_DIR/opencode/opencode.json" ~/.config/opencode/opencode.json

# Add require for custom.config if not already present
if ! grep -q 'require("custom.config")' ~/.config/nvim/lua/config/autocmds.lua 2>/dev/null; then
  echo 'require("custom.config")' >> ~/.config/nvim/lua/config/autocmds.lua
fi

echo "Dotfiles installed! Restart shell or open terminal."
