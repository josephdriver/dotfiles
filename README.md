# Dotfiles

Personal dotfiles for macOS and Linux with Neovim (LazyVim), Zsh, Starship, and Ghostty.

## Requirements

- Supported platforms:
  - macOS (Homebrew)
  - Ubuntu/Debian (apt)
  - Arch Linux (pacman)
- `curl` and `git`
- Linux only: `sudo` access for package installation

## Quick Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer handles package dependencies (brew/apt/pacman), nvm, Node LTS, tmux plugins, and on macOS installs Meslo Nerd Font + Ghostty + OpenCode CLI.

### Installer Options

```bash
./install.sh --dry-run
./install.sh --skip-shell-change
```

### Safe Testing (no changes to your real environment)

```bash
export TEST_HOME="$(mktemp -d)"
HOME="$TEST_HOME" ./install.sh --dry-run
rm -rf "$TEST_HOME"
```

This uses a temporary HOME directory and dry-run mode so your real dotfiles
and shell config are untouched.

## What's Included

- **Neovim** - LazyVim setup with Prettier formatting and ESLint linting
- **Zsh** - With zinit plugin manager, autosuggestions, syntax highlighting
- **Starship** - Cross-shell prompt
- **Ghostty** - Terminal emulator config (macOS)
- **Tmux** - Terminal multiplexer config
- **OpenCode** - Agent definitions and config

## Platform Notes

You do not need to pre-install dependencies manually. `./install.sh` installs required packages,
installs `nvm`, and installs Node.js LTS through `nvm`.

The sections below are only for manual preparation or troubleshooting.

### macOS

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Ubuntu/Debian

```bash
sudo apt update
sudo apt install git curl sudo
```

### Arch Linux (pacman)

```bash
sudo pacman -Syu
sudo pacman -S --noconfirm git curl sudo
```

## Post-Install Setup

### Tmux

After installation, reload tmux so it picks up the new config:

```bash
tmux source-file ~/.tmux.conf
```

If window styling still looks plain, install plugins once from inside tmux with `prefix + I`.

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

## Optional Tools (Manual Install)

### Ghostty (macOS)

Option 1: Homebrew cask

```bash
brew install --cask ghostty
```

Option 2: Manual download

1. Download the latest release from the Ghostty website.
2. Install the app in `/Applications`.
3. Launch Ghostty once to generate its support directory.

The config will already be linked at `~/.config/ghostty/config` after running the installer.

### OpenCode CLI

On macOS, `./install.sh` installs OpenCode automatically using the official installer.

For manual install (or non-macOS), run:

```bash
curl -fsSL https://opencode.ai/install | bash
```

Ensure the `opencode` binary is on your PATH (the default installer uses `~/.opencode/bin`), then verify with:

```bash
opencode --version
```

## License

MIT
