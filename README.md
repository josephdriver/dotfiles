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

Shared auto-format on save is enabled for:
- JavaScript/TypeScript (`.js`, `.ts`, `.jsx`, `.tsx`)
- JSON, CSS, SCSS, HTML

Machine-specific overrides can narrow that list with `nvim/lua/custom/local.lua`.

Manual format: `gq` in Normal mode or `:ConformInfo` to see available formatters

### Machine-Specific Neovim Config

Shared Neovim settings belong in `nvim/lua/custom/config.lua`. This repo loads an optional machine-specific override file from `nvim/lua/custom/local.lua` with `pcall(require, "custom.local")`.

Use `nvim/lua/custom/config.lua` for settings you want on every machine, such as tab width:

```lua
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
```

Use `nvim/lua/custom/local.lua` only for machine-specific behavior you do not want to commit. The file is optional; if it does not exist, the shared defaults in `nvim/lua/custom/config.lua` are used as-is.

An example override lives in `nvim/lua/custom/local.lua.example`. Copy it to `nvim/lua/custom/local.lua` and edit as needed:

```bash
cp nvim/lua/custom/local.lua.example nvim/lua/custom/local.lua
```

The local override file should return a Lua table. All keys are optional:

- `autoformat` - overrides `vim.g.autoformat`
- `format_patterns` - overrides the `BufWritePre` file patterns used by `conform`
- `ai.provider` - selects the AI autocomplete provider: `"copilot"`, `"codeium"`, or `"none"`
- `ai.mode` - selects how AI suggestions are shown; `"ghost_text"` is the current shared default

Example local override:

```lua
return {
  autoformat = false,
  format_patterns = { "*.js", "*.ts", "*.jsx", "*.tsx" },
  ai = {
    provider = "copilot",
    mode = "ghost_text",
  },
}
```

Example per-machine AI setups:

```lua
ai = {
  provider = "copilot",
  mode = "ghost_text",
}
```

```lua
ai = {
  provider = "codeium",
  mode = "ghost_text",
}
```

```lua
ai = {
  provider = "none",
}
```

Shared AI plugin wiring lives in `nvim/lua/plugins/ai.lua`. That file reads your local override and loads Copilot, Codeium, or no AI plugin at all. Authentication stays local to each machine.

For auth:

- Copilot - install the plugin, open Neovim, and run `:Copilot auth`
- Codeium - install the plugin, open Neovim, and run `:Codeium Auth`

`nvim/lua/custom/local.lua` is ignored by the repo, so it stays machine-specific by default.

If you also want to ignore it only locally without touching tracked ignore rules, you can use:

```bash
printf "\nnvim/lua/custom/local.lua\n" >> .git/info/exclude
```

If `nvim/lua/custom/local.lua` was accidentally added to git before, remove it from the index once and keep the file locally:

```bash
git rm --cached nvim/lua/custom/local.lua
```

To verify that only the local override is untracked, run:

```bash
git status --short
```

If you want to make shared Neovim changes to the repo, edit the tracked files normally and commit them as usual:

```bash
git add nvim/lua/custom/config.lua README.md
git commit -m "update neovim defaults"
```

Keep `nvim/lua/custom/local.lua` out of commits so it stays machine-specific.

### Linting

ESLint errors show as diagnostics (red highlights). Triggered on save.

### Keybindings

See `:Telescope keymaps` for all keybindings in LazyVim.

## Customization

- **nvim/lua/custom/config.lua** - Custom Neovim config
- **nvim/lua/custom/settings.lua** - Shared Neovim defaults merged with local overrides
- **nvim/lua/custom/local.lua.example** - Example machine-specific Neovim override
- **nvim/lua/custom/local.lua** - Optional machine-specific Neovim overrides
- **nvim/lua/plugins/ai.lua** - Shared AI autocomplete provider selector
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
