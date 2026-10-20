#!/usr/bin/env bash
# Install every package listed in apt_packages.txt in one apt call.
#
# Usage:
#   ./install_apt_packages.sh                  # core packages only
#   ./install_apt_packages.sh --playwright     # also the headless Chromium libraries
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

# Strip comments and blank lines, keep the first word of each line.
mapfile -t packages < <(sed 's/#.*//' "$here/apt_packages.txt" | awk 'NF {print $1}')

if [[ "${1:-}" == "--playwright" ]]; then
    # Shared libraries needed by the Chromium that Playwright downloads.
    packages+=(libatk1.0-0t64 libatk-bridge2.0-0t64 libatspi2.0-0t64 libgbm1
               libxcomposite1 libxdamage1 libxrandr2 libcups2t64 libpango-1.0-0)
fi

sudo apt-get update
sudo apt-get install -y "${packages[@]}"

# Let the current user run docker without sudo (takes effect at next login).
sudo usermod -aG docker "$USER"
echo "Done. Log out and back in for the docker group to apply."
