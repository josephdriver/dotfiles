#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${HOME:-}" ] || [ "${HOME:-}" = "/" ]; then
  HOME="$(eval echo "~$(id -un)")"
fi

if [ -z "${HOME:-}" ] || [ "${HOME:-}" = "/" ]; then
  printf "error: HOME is not set correctly\n" >&2
  exit 1
fi

DRY_RUN=0
SKIP_SHELL_CHANGE=0

BACKUP_ROOT="$HOME/.dotfiles-backup"
BACKUP_DIR=""

log() {
  printf "%s\n" "$*"
}

warn() {
  printf "warning: %s\n" "$*" >&2
}

fail() {
  printf "error: %s\n" "$*" >&2
  exit 1
}

run_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "+ %s\n" "$*"
  else
    "$@"
  fi
}

run_cmd_bash() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf "+ %s\n" "$*"
  else
    bash -c "$*"
  fi
}

ensure_dir() {
  if [ ! -d "$1" ]; then
    run_cmd mkdir -p "$1"
  fi
}

ensure_backup_dir() {
  if [ -z "$BACKUP_DIR" ]; then
    BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"
    run_cmd mkdir -p "$BACKUP_DIR"
  fi
}

backup_target() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    ensure_backup_dir
    run_cmd mv "$target" "$BACKUP_DIR/"
  fi
}

link_item() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"

  ensure_dir "$dest_dir"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    log "link exists: $dest"
    return
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup_target "$dest"
  fi

  run_cmd ln -sfn "$src" "$dest"
}

append_line_once() {
  local file="$1"
  local line="$2"
  ensure_dir "$(dirname "$file")"
  if [ ! -f "$file" ]; then
    run_cmd_bash "printf '%s\n' '$line' > '$file'"
    return
  fi
  if ! grep -qF "$line" "$file" 2>/dev/null; then
    run_cmd_bash "printf '%s\n' '$line' >> '$file'"
  fi
}

write_file_if_missing() {
  local file="$1"
  local content="$2"

  if [ -f "$file" ]; then
    return
  fi

  ensure_dir "$(dirname "$file")"

  if [ "$DRY_RUN" -eq 1 ]; then
    printf "+ create %s\n" "$file"
    return
  fi

  printf "%s\n" "$content" > "$file"
}

detect_os() {
  local uname_out
  uname_out="$(uname -s)"
  case "$uname_out" in
    Darwin)
      echo "macos"
      ;;
    Linux)
      echo "linux"
      ;;
    *)
      fail "unsupported OS: $uname_out"
      ;;
  esac
}

detect_pkg_manager() {
  local os="$1"

  if [ "$os" = "macos" ]; then
    echo "brew"
    return
  fi

  if command -v apt-get >/dev/null 2>&1; then
    echo "apt"
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    echo "pacman"
    return
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "brew"
    return
  fi

  fail "supported package manager not found (apt or pacman)"
}

ensure_sudo() {
  if [ "$(id -u)" -ne 0 ] && ! command -v sudo >/dev/null 2>&1; then
    fail "sudo not found and not running as root"
  fi
}

ensure_brew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  log "Installing Homebrew..."
  run_cmd_bash '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

  if [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
  elif [ -d "/usr/local/bin" ]; then
    export PATH="/usr/local/bin:$PATH"
  fi
}

pm_update() {
  local pm="$1"

  case "$pm" in
    brew)
      run_cmd brew update
      ;;
    apt)
      ensure_sudo
      run_cmd sudo apt-get update
      ;;
    pacman)
      ensure_sudo
      run_cmd sudo pacman -Syy --noconfirm
      ;;
    *)
      fail "unknown package manager: $pm"
      ;;
  esac
}

brew_pkg_command() {
  case "$1" in
    git) echo "git" ;;
    curl) echo "curl" ;;
    zsh) echo "zsh" ;;
    tmux) echo "tmux" ;;
    neovim) echo "nvim" ;;
    starship) echo "starship" ;;
    fzf) echo "fzf" ;;
    ripgrep) echo "rg" ;;
    fd) echo "fd" ;;
    unzip) echo "unzip" ;;
    *) echo "" ;;
  esac
}

pm_has_package() {
  local pm="$1"
  local pkg="$2"
  local cmd

  case "$pm" in
    brew)
      cmd="$(brew_pkg_command "$pkg")"
      if [ -n "$cmd" ] && command -v "$cmd" >/dev/null 2>&1; then
        return 0
      fi
      brew list --versions "$pkg" >/dev/null 2>&1
      ;;
    apt)
      dpkg -s "$pkg" >/dev/null 2>&1
      ;;
    pacman)
      pacman -Qi "$pkg" >/dev/null 2>&1
      ;;
    *)
      return 1
      ;;
  esac
}

pm_install() {
  local pm="$1"
  shift
  if [ "$#" -eq 0 ]; then
    return
  fi

  case "$pm" in
    brew)
      run_cmd brew install "$@"
      ;;
    apt)
      ensure_sudo
      run_cmd sudo apt-get install -y "$@"
      ;;
    pacman)
      ensure_sudo
      run_cmd sudo pacman -S --noconfirm "$@"
      ;;
    *)
      fail "unknown package manager: $pm"
      ;;
  esac
}

install_packages() {
  local pm="$1"
  shift
  local pkgs=("$@")
  local missing=()
  local pkg

  for pkg in "${pkgs[@]}"; do
    if ! pm_has_package "$pm" "$pkg"; then
      missing+=("$pkg")
    fi
  done

  if [ "${#missing[@]}" -eq 0 ]; then
    log "Packages already installed for $pm"
    return
  fi

  log "Installing packages via $pm: ${missing[*]}"
  pm_update "$pm"
  pm_install "$pm" "${missing[@]}"
}

ensure_fd_symlink() {
  if command -v fd >/dev/null 2>&1; then
    return
  fi
  if command -v fdfind >/dev/null 2>&1; then
    ensure_dir "$HOME/.local/bin"
    run_cmd ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
  fi
}

install_zinit() {
  if [ ! -d "$HOME/.zinit/bin" ]; then
    run_cmd git clone https://github.com/zdharma-continuum/zinit.git "$HOME/.zinit/bin"
  fi
}

install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    run_cmd git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  fi
}

install_tpm_plugins() {
  local installer="$HOME/.tmux/plugins/tpm/bin/install_plugins"
  if [ ! -x "$installer" ]; then
    return
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    printf "+ %s\n" "$installer"
    return
  fi

  if ! "$installer" >/dev/null 2>&1; then
    warn "tmux plugins were not auto-installed; run prefix + I inside tmux"
  fi
}

install_meslo_font() {
  local os="$1"
  if [ "$os" != "macos" ]; then
    return
  fi

  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew not found, skipping Meslo Nerd Font install"
    return
  fi

  if brew list --cask font-meslo-lg-nerd-font >/dev/null 2>&1; then
    return
  fi

  log "Installing Meslo Nerd Font via Homebrew cask..."
  run_cmd brew tap homebrew/cask-fonts
  run_cmd brew install --cask font-meslo-lg-nerd-font
}

install_ghostty() {
  local os="$1"
  if [ "$os" != "macos" ]; then
    return
  fi

  if ! command -v brew >/dev/null 2>&1; then
    warn "Homebrew not found, skipping Ghostty install"
    return
  fi

  if brew list --cask ghostty >/dev/null 2>&1; then
    return
  fi

  log "Installing Ghostty via Homebrew cask..."
  run_cmd brew install --cask ghostty
}

install_opencode() {
  local os="$1"
  if [ "$os" != "macos" ]; then
    return
  fi

  if command -v opencode >/dev/null 2>&1; then
    return
  fi

  log "Installing OpenCode CLI via official installer..."
  run_cmd_bash "curl -fsSL https://opencode.ai/install | bash"

  if [ -d "$HOME/.opencode/bin" ]; then
    export PATH="$HOME/.opencode/bin:$PATH"
  fi
}

install_nvm() {
  local nvm_dir="$HOME/.nvm"

  if [ -s "$nvm_dir/nvm.sh" ]; then
    return
  fi

  log "Installing nvm..."
  run_cmd_bash "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
}

load_nvm() {
  export NVM_DIR="$HOME/.nvm"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1090
    . "$NVM_DIR/nvm.sh"
  fi
}

install_node_lts() {
  if ! command -v nvm >/dev/null 2>&1; then
    return
  fi
  log "Installing Node.js LTS via nvm..."
  run_cmd nvm install --lts
  run_cmd nvm alias default "lts/*"
}

set_default_shell() {
  if [ "$SKIP_SHELL_CHANGE" -eq 1 ]; then
    return
  fi

  if [ "${SHELL:-}" = "$(command -v zsh)" ]; then
    return
  fi

  if ! command -v zsh >/dev/null 2>&1; then
    warn "zsh not found, skipping shell change"
    return
  fi

  if ! grep -q "$(command -v zsh)" /etc/shells 2>/dev/null; then
    warn "zsh is not in /etc/shells, skipping shell change"
    return
  fi

  log "Setting zsh as default shell..."
  if ! run_cmd chsh -s "$(command -v zsh)"; then
    warn "failed to change default shell"
  fi
}

link_dotfiles() {
  log "Symlinking dotfiles..."

  ensure_dir "$HOME/.config"
  ensure_dir "$HOME/.config/nvim/lua"
  ensure_dir "$HOME/.config/nvim/lua/config"
  ensure_dir "$HOME/.config/opencode"

  link_item "$SCRIPT_DIR/zsh/.zshrc" "$HOME/.zshrc"
  link_item "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"
  link_item "$SCRIPT_DIR/nvim/lua/custom" "$HOME/.config/nvim/lua/custom"
  link_item "$SCRIPT_DIR/nvim/lua/plugins" "$HOME/.config/nvim/lua/plugins"
  link_item "$SCRIPT_DIR/nvim/lua/config" "$HOME/.config/nvim/lua/config"
  link_item "$SCRIPT_DIR/nvim/lazyvim.json" "$HOME/.config/nvim/lazyvim.json"
  link_item "$SCRIPT_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
  link_item "$SCRIPT_DIR/opencode/agents" "$HOME/.config/opencode/agents"
  link_item "$SCRIPT_DIR/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
}

link_ghostty_config() {
  local os="$1"
  if [ "$os" != "macos" ]; then
    log "Skipping Ghostty config (macOS only)"
    return
  fi

  ensure_dir "$HOME/.config/ghostty"
  link_item "$SCRIPT_DIR/ghostty/config" "$HOME/.config/ghostty/config"
}

ensure_neovim_hook() {
  append_line_once "$HOME/.config/nvim/lua/config/autocmds.lua" 'require("custom.config")'
}

ensure_lazyvim_bootstrap() {
  local nvim_dir="$HOME/.config/nvim"

  write_file_if_missing "$nvim_dir/init.lua" 'require("config.lazy")'

  write_file_if_missing "$nvim_dir/lua/config/lazy.lua" 'local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})'
}

fix_lazyvim_plugins_import() {
  local lazy_file="$HOME/.config/nvim/lua/config/lazy.lua"
  local plugins_dir="$HOME/.config/nvim/lua/plugins"

  if [ ! -f "$lazy_file" ] || [ -d "$plugins_dir" ]; then
    return
  fi

  if ! grep -qF '{ import = "plugins" },' "$lazy_file" 2>/dev/null; then
    return
  fi

  log "Updating LazyVim bootstrap to remove missing plugins import..."

  if [ "$DRY_RUN" -eq 1 ]; then
    printf "+ patch %s\n" "$lazy_file"
    return
  fi

  run_cmd python3 -c "from pathlib import Path; p=Path('$lazy_file'); t=p.read_text(); p.write_text(t.replace('    { import = \"plugins\" },\\n', ''))"
}

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --dry-run             Print actions without executing
  --skip-shell-change   Do not change default shell to zsh
  -h, --help            Show this help
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --dry-run)
        DRY_RUN=1
        ;;
      --skip-shell-change)
        SKIP_SHELL_CHANGE=1
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "unknown option: $1"
        ;;
    esac
    shift
  done
}

main() {
  parse_args "$@"

  local os
  local pm
  os="$(detect_os)"
  pm="$(detect_pkg_manager "$os")"

  log "Detected OS: $os"
  log "Detected package manager: $pm"

  if [ "$pm" = "brew" ]; then
    ensure_brew
  fi

  if [ "$pm" = "apt" ]; then
    install_packages "$pm" git curl zsh tmux neovim starship fzf ripgrep fd-find unzip build-essential xclip
  elif [ "$pm" = "pacman" ]; then
    install_packages "$pm" git curl zsh tmux neovim starship fzf ripgrep fd unzip base-devel xclip
  else
    install_packages "$pm" git curl zsh tmux neovim starship fzf ripgrep fd
  fi

  ensure_fd_symlink
  install_nvm
  load_nvm
  install_node_lts

  install_zinit
  install_tpm
  install_tpm_plugins
  install_meslo_font "$os"
  install_ghostty "$os"
  install_opencode "$os"

  link_dotfiles
  link_ghostty_config "$os"
  ensure_lazyvim_bootstrap
  fix_lazyvim_plugins_import
  ensure_neovim_hook
  set_default_shell

  log "Dotfiles installed! Restart your shell or open a new terminal."
  if [ -n "$BACKUP_DIR" ]; then
    log "Backups stored in: $BACKUP_DIR"
  fi
}

main "$@"
