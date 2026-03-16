# AGENTS

## Scope
This repository provides a standardized development environment for macOS and Linux. It focuses on shell configuration, terminal tooling, editor setup, and prompt theming, installed via symlinks and light bootstrap scripts.

## What’s Included
- Shell: Zsh configuration, aliases, PATH setup, and zinit-based plugins.
- Editor: Neovim with LazyVim presets and formatting/linting extras.
- Terminal: Tmux configuration with Catppuccin styling.
- Prompt: Starship prompt with Catppuccin palette.
- Terminal emulator: Ghostty config (macOS-focused).
- OpenCode: Local agent definitions and config.

## Tech Stack
- Shell: Zsh, zinit
- Editor: Neovim, LazyVim, conform.nvim
- Terminal multiplexer: tmux
- Prompt: Starship
- Terminal emulator config: Ghostty
- Package managers used in setup docs: Homebrew, apt, nvm
- AI tooling: OpenCode config + custom subagents

## Installation Flow (High Level)
- `install.sh` creates required config dirs, installs zinit/TPM if missing, and symlinks dotfiles into `~/.config` and home.
- A small Neovim hook is appended to enable custom formatting config.

## Key Files
- `install.sh`
- `zsh/.zshrc`, `zsh/aliases.zsh`, `zsh/path.zsh`
- `nvim/lazyvim.json`, `nvim/lua/custom/config.lua`
- `tmux/.tmux.conf`
- `ghostty/config`
- `starship.toml`
- `opencode/opencode.json`, `opencode/agents/*.md`
- `KEYBINDS.md`, `glow/catppuccin-mocha.json`

## Assumptions
- Users have or will install core tools (git, zsh, starship, node, nvm).
- The default shell is zsh and `~/.zshrc` is sourced.

## Open Questions
Answering these helps keep AGENTS.md accurate as the repo evolves:
- Do you want to document Linux-only vs macOS-only differences explicitly?
- Should we include a “Supported tools” list (e.g., required fonts, Ghostty availability, etc.)?
- Is the Neovim setup intended to stay default LazyVim, or will custom keymaps/plugins be added soon?
