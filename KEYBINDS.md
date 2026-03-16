# Keybinds Cheat Sheet

```
  _  __          _     _           _
 | |/ /___ _   _| |__ (_)_ __   __| |___
 | ' // _ \ | | | '_ \| | '_ \ / _` / __|
 | . \  __/ |_| | |_) | | | | | (_| \__ \
 |_|\_\___|\__, |_.__/|_|_| |_|\__,_|___/
           |___/
```

Catppuccin Mocha
- rosewater `#f5e0dc`  flamingo `#f2cdcd`  pink `#f5c2e7`  mauve `#cba6f7`
- red `#f38ba8`  maroon `#eba0ac`  peach `#fab387`  yellow `#f9e2af`
- green `#a6e3a1`  teal `#94e2d5`  sky `#89dceb`  sapphire `#74c7ec`
- blue `#89b4fa`  lavender `#b4befe`  text `#cdd6f4`  crust `#11111b`

## Sources

Generated from:
- LazyVim default keymaps (docs)
- `tmux/.tmux.conf`
- `ghostty/config`

## Leader Keys
- Nvim leader: `Space`
- Nvim localleader: `\`
- Tmux prefix: `C-a`

## Quick Picks

### Nvim (buffers, git, file tree, panes)
- Buffers: `]b` next, `[b` prev, `<S-l>` next, `<S-h>` prev
- Close buffer: `<leader>bd` delete, `<leader>bo` delete others
- New file/buffer: `<leader>fn` new file
- File tree: `<leader>e` explorer (root), `<leader>E` explorer (cwd)
- Pane navigation: `<C-h>` left, `<C-j>` down, `<C-k>` up, `<C-l>` right
- Git: `<leader>gs` status, `<leader>gd` diff (hunks), `<leader>gD` diff (origin)
- Search: `<leader><space>` find files (root), `<leader>fr` recent, `<leader>/` grep (root)
- Search results: `n` next, `N` previous

### Tmux (windows, sessions, panes)
- Rename window: `prefix` + `R`
- New window: `prefix` + `c`
- Close window: `prefix` + `&` (tmux default)
- Session list: `prefix` + `s`
- Split pane: `prefix` + `|` (right), `prefix` + `-` (down)
- Pane navigation: `prefix` + `h/j/k/l`

### Ghostty (tabs, splits)
- New tab: `cmd+t` (macOS) / `super+t` (Linux)
- Next/prev tab: `cmd+shift+]` / `cmd+shift+[`, `super+shift+]` / `super+shift+[`
- New split: `cmd+enter` right, `cmd+shift+enter` down (macOS)
- Focus split: `cmd+option+h/j/k/l` (macOS) / `super+alt+h/j/k/l` (Linux)
- Toggle split zoom: `cmd+shift+\` (macOS) / `super+shift+\` (Linux)

## Full List

### Nvim (LazyVim defaults)
- Buffers
  - `]b` next buffer
  - `[b` previous buffer
  - `<S-l>` next buffer
  - `<S-h>` previous buffer
  - `<leader>bb` switch to other buffer
  - `<leader>bd` delete buffer
  - `<leader>bo` delete other buffers
  - `<leader>bD` delete buffer and window
  - `<leader>bj` pick buffer
  - `<leader>br` delete buffers to the right
  - `<leader>bl` delete buffers to the left
- File tree / explorer
  - `<leader>e` explorer (root dir)
  - `<leader>E` explorer (cwd)
  - `<leader>fe` explorer (root dir)
  - `<leader>fE` explorer (cwd)
- Git
  - `<leader>gs` git status
  - `<leader>gd` git diff (hunks)
  - `<leader>gD` git diff (origin)
  - `<leader>gL` git log (cwd)
  - `<leader>gl` git log
  - `<leader>gb` git blame line
  - `<leader>gf` file history
- Search (Telescope / Snacks)
  - `<leader><space>` find files (root)
  - `<leader>ff` find files (root)
  - `<leader>fF` find files (cwd)
  - `<leader>fr` recent files
  - `/` search in file (vim search)
  - `<leader>/` grep (root)
  - `n` next search result
  - `N` previous search result
- Window / pane navigation
  - `<C-h>` go to left window
  - `<C-j>` go to lower window
  - `<C-k>` go to upper window
  - `<C-l>` go to right window
  - `<leader>-` split window below
  - `<leader>|` split window right
  - `<leader>wd` delete window
  - `<leader>wm` toggle zoom mode

### Tmux (from tmux/.tmux.conf)
- Prefix: `C-a`
- Windows
  - `prefix` + `c` new window
  - `prefix` + `n` next window
  - `prefix` + `p` previous window
  - `prefix` + `w` choose window
  - `prefix` + `R` rename window
  - `prefix` + `&` kill window (tmux default)
- Sessions
  - `prefix` + `s` choose session
- Panes
  - `prefix` + `|` split right
  - `prefix` + `-` split down
  - `prefix` + `h/j/k/l` move between panes
  - `prefix` + `H/J/K/L` resize pane
- Copy mode
  - `prefix` + `[` enter copy mode (tmux default)
  - `v` begin selection (copy-mode-vi)
  - `y` copy selection (copy-mode-vi)
- Reload config
  - `prefix` + `r`

### Ghostty (from ghostty/config)
- Tabs
  - `cmd+t` new tab (macOS)
  - `cmd+shift+[` previous tab (macOS)
  - `cmd+shift+]` next tab (macOS)
  - `cmd+1..4` go to tab 1..4 (macOS)
  - `super+t` new tab (Linux)
  - `super+shift+[` previous tab (Linux)
  - `super+shift+]` next tab (Linux)
  - `super+1..4` go to tab 1..4 (Linux)
- Splits
  - `cmd+enter` new split right (macOS)
  - `cmd+shift+enter` new split down (macOS)
  - `cmd+option+h/j/k/l` focus split (macOS)
  - `cmd+shift+\` toggle split zoom (macOS)
  - `super+enter` new split right (Linux)
  - `super+shift+enter` new split down (Linux)
  - `super+alt+h/j/k/l` focus split (Linux)
  - `super+shift+\` toggle split zoom (Linux)

## Notes
- For the complete, current Nvim map list: `<leader>sk` (Search Keymaps) or `:Telescope keymaps`.
