#!/usr/bin/env bash
# Install every package listed in apt_packages.txt in one apt call.
#
# Usage:
#   ./install_apt_packages.sh                  # core packages only
#   ./install_apt_packages.sh --latex          # also the [latex] packages (TeX Live, large)
#   ./install_apt_packages.sh --playwright     # also the headless Chromium libraries
# Options can be combined: ./install_apt_packages.sh --latex --playwright
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

groups=""
playwright=0
for arg in "$@"; do
    case "$arg" in
        --latex) groups+=" [latex]" ;;
        --playwright) playwright=1 ;;
        *) echo "Unknown option: $arg" >&2; exit 1 ;;
    esac
done

# Strip comments and blank lines. Keep untagged packages, and tagged ones
# ("package [group]") only when their group was requested.
mapfile -t packages < <(
    sed 's/#.*//' "$here/apt_packages.txt" |
    awk -v groups="$groups" '
        BEGIN { n = split(groups, g, " "); for (i = 1; i <= n; i++) want[g[i]] = 1 }
        NF == 1 { print $1 }
        NF >= 2 && ($2 in want) { print $1 }
    '
)

if [[ $playwright == 1 ]]; then
    # Shared libraries needed by the Chromium that Playwright downloads.
    packages+=(libatk1.0-0t64 libatk-bridge2.0-0t64 libatspi2.0-0t64 libgbm1
               libxcomposite1 libxdamage1 libxrandr2 libcups2t64 libpango-1.0-0)
fi

sudo apt-get update
sudo apt-get install -y "${packages[@]}"

# Let the current user run docker without sudo (takes effect at next login).
sudo usermod -aG docker "$USER"
echo "Done. Log out and back in for the docker group to apply."
