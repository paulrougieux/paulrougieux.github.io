# Server Setup

# rsync

Copy dot files to the `paul@flower` server.

Run these commands from the `setup/` directory (i.e. the parent of this `server/`
folder), since paths are given relative to it.

```bash

cd ~/rp/paulrougieux.github.io/setup
ssh paul@flower mkdir -p ~/.tmux ~/.config/nvim
rsync -av server/work.tmux paul@flower:~/.tmux/work.tmux
rsync -av .bash_aliases paul@flower:~/.bash_aliases
rsync -av --delete server/nvim_server/ paul@flower:~/.config/nvim/

```

- `ssh ... mkdir -p`: creates the destination directories on the remote first,
  since rsync won't create missing parent directories for a single-file target
  (it needs `~/.tmux/` and `~/.config/nvim/` to already exist).
- `-a` (archive): preserves permissions, timestamps, symlinks, and recurses into
  directories.
- `-v` (verbose): prints each file transferred.
- `--delete` (nvim config only): removes files under `~/.config/nvim/` on the
  server that no longer exist locally, keeping the two in sync. Not used for the
  single-file copies since there's nothing to prune. Drop it if you want a purely
  additive copy.
- Trailing slash on `server/nvim_server/`: copies the directory's *contents* into
  `~/.config/nvim/`, rather than nesting a `nvim_server/` folder inside it.

## Neovim Configuration

The `nvim_server` configuration is a partial transfer of the laptop's Neovim config,
adapted for server environments. It includes the core editor settings and keybindings
but may not contain all plugins or features from the main config.

When syncing or updating, maintain both the server-specific tweaks and any changes
from the laptop config.
