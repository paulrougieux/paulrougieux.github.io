#!/usr/bin/env bash
# Symlink dotfiles from the read only clone of the paulrougieux repository
# into the home directory. Existing files are moved to <name>.bak first.
#
# Usage:
#   ./link_dotfiles.sh            # expects the clone at ~/rp/paulrougieux
#   SETUP=/other/path/setup ./link_dotfiles.sh
set -euo pipefail

SETUP="${SETUP:-$HOME/rp/paulrougieux/setup}"

if [[ ! -d "$SETUP" ]]; then
    echo "Setup directory not found: $SETUP" >&2
    echo "Clone it first:" >&2
    echo "  git clone https://gitlab.com/paulrougieux/paulrougieux.git ~/rp/paulrougieux" >&2
    exit 1
fi

# link <source in the clone> <target in home>
link() {
    local src="$1" dst="$2"
    mkdir -p "$(dirname "$dst")"
    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        mv "$dst" "$dst.bak"
        echo "Backed up $dst to $dst.bak"
    fi
    ln -s "$src" "$dst"
    echo "$dst -> $src"
}

link "$SETUP/.bash_aliases"            "$HOME/.bash_aliases"
link "$SETUP/server/.tmux.conf"        "$HOME/.tmux.conf"
link "$SETUP/server/work.tmux"         "$HOME/.tmux/work.tmux"
link "$SETUP/server/.gitconfig"        "$HOME/.gitconfig"
link "$SETUP/.gitignore_global"        "$HOME/.gitignore_global"
link "$SETUP/server/nvim_server"       "$HOME/.config/nvim"
