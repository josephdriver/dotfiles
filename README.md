# Dotfiles

Personal dotfiles for macOS and Linux with Neovim (LazyVim), Zsh, Starship, and Ghostty.

## Requirements

- macOS or Linux
- Zsh
- Git

## Quick Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## What's Included

- **Neovim** - LazyVim setup with Prettier formatting and ESLint linting
- **Zsh** - With zinit plugin manager, autosuggestions, syntax highlighting
- **Starship** - Cross-shell prompt
- **Ghostty** - Terminal emulator config (macOS)
- **Tmux** - Terminal multiplexer config
- **OpenCode** - Agent definitions and config

## Prerequisites by Platform

### macOS

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install essentials
brew install starship node npm git zsh

# Set zsh as default shell
chsh -s /bin/zsh

# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.zshrc
nvm install 20
```

### Linux

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install git zsh curl build-essential

# Install Homebrew (optional but recommended)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install starship
brew install starship

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 20

# Set zsh as default shell
chsh -s /bin/zsh
```

## Post-Install Setup

### Tmux

After installation, reload tmux so it picks up the new config:

```bash
tmux source-file ~/.tmux.conf
```

### Neovim Plugins

1. Open Neovim: `nvim`
2. Run `:Lazy` to sync plugins
3. Install LSP servers: `:Mason`
   - Install `eslint` (required for linting)
   - Install `prettierd` (optional, local prettier is used if available)

### Project Dependencies

For each project, ensure dependencies are installed:

```bash
cd your-project
npm install
```

This ensures:
- Local prettier is available in `node_modules/.bin/prettier`
- Local eslint is available in `node_modules/.bin/eslint`

## Usage

### OpenCode Agents

Two custom subagents are included for OpenCode:

- `@research` for structured research briefs and planning inputs
- `@code-review` for security, performance, and readability-focused reviews

Agent definitions live in `opencode/agents`. The base config is `opencode/opencode.json`.

### Formatting

Auto-format on save is enabled for:
- JavaScript/TypeScript (`.js`, `.ts`, `.jsx`, `.tsx`)
- JSON, CSS, SCSS, HTML

Manual format: `gq` in Normal mode or `:ConformInfo` to see available formatters

### Linting

ESLint errors show as diagnostics (red highlights). Triggered on save.

### Keybindings

See `:Telescope keymaps` for all keybindings in LazyVim.

## Customization

- **nvim/lua/custom/config.lua** - Custom Neovim config
- **nvim/lazyvim.json** - LazyVim extras (enabled via `:LazyExtras`)
- **zsh/aliases.zsh** - Custom aliases
- **zsh/path.zsh** - Custom PATH additions
- **opencode/agents** - OpenCode custom agents
- **opencode/opencode.json** - OpenCode config

## Troubleshooting

### Prettier not found

Ensure Node.js is in PATH:
```bash
source ~/.zshrc
which node  # Should return a path
```

### ESLint not linting

1. Open a JS/JSX file
2. Run `:Mason` and ensure eslint is installed
3. Check `:LspInfo` to see if eslint is attached

### LazyVim not loading extras

Run `:Lazy` to sync and check for errors.

## License

MIT
