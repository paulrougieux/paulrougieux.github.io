# Setting up a Debian modelling server

## Why a modelling server

Forest sector models such as `eu_cbm_hat`, `cobwood` or the CBM–TIMBA coupling
run for hours, write gigabytes of output and need the same Python environment
every time. A laptop is a poor host for that: it sleeps, it moves between
networks, and its environment drifts as other projects come and go.

A small Debian VPS solves this. You connect over `ssh`, start a run inside
`tmux`, close the laptop, and come back later to the same session with the
logs still scrolling. The same machine can host coding agents in Docker
containers (see `containers/` in the `agents_toolbox` repository) that work
on a project while you are away.

The aim of this document is to make a fresh Debian 13 server feel like the
existing one in about fifteen minutes:

1. Install the apt packages.
2. Clone the personal configuration repository read only.
3. Symlink the dotfiles: bash aliases, tmux, git, Neovim.
4. Install the tools that do not come from apt (uv, Claude Code, pi).

Files in this directory:

| File | Purpose |
|------|---------|
| [apt_packages.txt](apt_packages.txt) | Commented list of the apt packages to install |
| [install_apt_packages.sh](install_apt_packages.sh) | Installs everything in that list in one `apt-get` call |
| [link_dotfiles.sh](link_dotfiles.sh) | Symlinks dotfiles from the `paulrougieux` clone into `$HOME` |

This directory lives in `setup/debian_server/` of the `paulrougieux`
repository, the same repository that holds the dotfiles. A new Debian cloud
image has `git` missing, so the very first step is to install it by hand
(see [Bootstrapping sudo](#bootstrapping-sudo) if `sudo` is missing too) and
clone the repository (details in section 2):

```bash
sudo apt install git
mkdir -p ~/rp && git clone https://gitlab.com/paulrougieux/paulrougieux.git ~/rp/paulrougieux
```

Alternatively, copy this directory from the laptop:

```bash
rsync -av ~/rp/paulrougieux.github.io/setup/debian_server/ newserver:~/debian_server/
```


## 1. Apt packages

```bash
cd ~/rp/paulrougieux/setup/debian_server
./install_apt_packages.sh
```

### How the list was built

`apt-mark showmanual` on the current server lists 158 packages, but most of
them come from the Debian cloud image (`cloud-init`, `grub-cloud-amd64`,
`libc6`, ...) and are already on any new VPS. The list in
`apt_packages.txt` is built from `/var/log/apt/history.log` instead: it only
keeps the packages that were installed on purpose with `apt install`.

### Choices made

- **Groups.** Packages are grouped by role (terminal, version control,
  Python, build tools, containers, documents), each with a one-line comment,
  so the file doubles as documentation.
- **`python3-venv` instead of `python3.13-venv`.** The unversioned package
  pulls the right version and keeps working after the next Debian release.
- **`kitty-terminfo` instead of `kitty`.** The full `kitty` package was
  installed on the old server only so that `ssh` from the kitty terminal on
  the laptop works (it needs the `xterm-kitty` terminfo entry). The
  `kitty-terminfo` package provides exactly that, without a GUI and its
  libraries.
- **`build-essential` added explicitly.** On the old server `gcc` and
  `make` arrived as a side effect of `python3-pip`. They are needed by
  nvim-treesitter to compile parsers and by some pip packages that build
  from source, so they are now listed on purpose.
- **`docker.io` from Debian**, not Docker's own repository. It is older but
  updated by `unattended-upgrades` with the rest of the system and needs no
  extra apt source. The script also adds the user to the `docker` group.
- **Playwright libraries are optional.** Nine libraries (`libatk1.0-0t64`,
  `libgbm1`, `libxcomposite1`, ...) were installed so that the headless
  Chromium of Playwright can run (for agents that browse or render web
  pages). They are only installed with
  `./install_apt_packages.sh --playwright`.
- **`sudo` and `curl` listed explicitly.** Both come with the Debian cloud
  image of the old VPS but are missing from the university image.
- **Left out.** `cron`, `vim`, `openssh-server`, `unattended-upgrades` and
  similar are part of the Debian cloud image. If one is missing on a new
  image, add it to the list.

### Bootstrapping sudo

`install_apt_packages.sh` calls `sudo`, so on an image without it, install
it as root first and add your user to the `sudo` group:

```bash
su -
apt update && apt install sudo
usermod -aG sudo paul
exit
```

Log out and back in for the group to apply, then run the script.

Check what landed with:

```bash
apt-mark showmanual | sort > /tmp/manual.txt
```


## 2. Read only clone of the `paulrougieux` repository

The repository [gitlab.com/paulrougieux/paulrougieux](https://gitlab.com/paulrougieux/paulrougieux)
contains the blog and, in its `setup/` directory, the dotfiles used on the
laptop and on servers. On a server it is cloned over HTTPS, without an ssh
key:

```bash
mkdir -p ~/rp
git clone https://gitlab.com/paulrougieux/paulrougieux.git ~/rp/paulrougieux
```

**Read only** here means the server pulls but never pushes:

- Cloning over HTTPS from a public repository needs no credentials, so the
  server holds no key that could write to GitLab.
- Edits to the dotfiles are made on the laptop, committed and pushed there.
  On the server, update with:

  ```bash
  git -C ~/rp/paulrougieux pull --autostash
  ```

  `--autostash` matters because lazy.nvim rewrites `lazy-lock.json` inside
  the clone when plugins update (see the Neovim section).

To make an accidental push fail loudly, point the push URL nowhere:

```bash
git -C ~/rp/paulrougieux remote set-url --push origin no_push
```

The relevant files in the clone:

```
setup/
├── .bash_aliases          # aliases and environment variables
├── .gitignore_global      # global git ignore list
├── debian_server/         # this guide, the apt package list and the scripts
└── server/
    ├── README.md          # older rsync-based deployment notes
    ├── .gitconfig         # git identity and aliases
    ├── .tmux.conf         # tmux configuration
    ├── work.tmux          # window layout for a work session
    └── nvim_server/       # minimal Neovim config for servers
```


## 3. Symlinks

```bash
~/rp/paulrougieux/setup/debian_server/link_dotfiles.sh
```

This creates:

| Link in `$HOME` | Points to |
|-----------------|-----------|
| `~/.bash_aliases` | `~/rp/paulrougieux/setup/.bash_aliases` |
| `~/.tmux.conf` | `~/rp/paulrougieux/setup/server/.tmux.conf` |
| `~/.tmux/work.tmux` | `~/rp/paulrougieux/setup/server/work.tmux` |
| `~/.gitconfig` | `~/rp/paulrougieux/setup/server/.gitconfig` |
| `~/.gitignore_global` | `~/rp/paulrougieux/setup/.gitignore_global` |
| `~/.config/nvim` | `~/rp/paulrougieux/setup/server/nvim_server` |

Existing files are renamed to `<name>.bak` rather than overwritten.

### Why symlinks rather than copies

The old server received copies pushed from the laptop with `rsync` (see
`setup/server/README.md`). Copies drift: a fix made on the laptop has to be
pushed to every server by hand. With symlinks into a clone, one
`git pull` updates every configuration file at once, and `git diff` in the
clone shows any local change made on the server.

The trade-off is that the server configuration is whatever is on the
`master` branch. Experimental changes belong on a branch on the laptop until
they are ready.

### The `~/rp` shortcut

Paths in the aliases and in this repository use `~/rp/...`. On the current
server `~/rp` is itself a symlink to `~/repos`:

```bash
mkdir -p ~/repos && ln -s repos ~/rp
```

Do this *before* cloning if you want the same layout, then clone into
`~/rp/...` as above.


## 4. Bash aliases

Debian's default `~/.bashrc` already sources `~/.bash_aliases` when it
exists, so the symlink is all that is needed. Open a new shell or run
`source ~/.bashrc`.

Useful aliases on a server:

- `vi` → `nvim`, and `viz` opens a file picked with `fzf`.
- `ll`, `tree2` for quick listings.
- `EDITOR=nvim` so git and other tools open Neovim.

Some aliases only make sense on the laptop (`open` uses `xdg-open`, the
music and picture aliases need `yt-dlp` or ImageMagick). They are harmless
on a server: they fail only if called.

`~/.local/bin` must be on `PATH` for tools installed by `uv`, `pipx` and
the Claude Code installer. Debian's default `~/.profile` adds it if the
directory exists at login, so create it early:

```bash
mkdir -p ~/.local/bin
```


## 5. tmux

`~/.tmux.conf` is linked from `setup/server/.tmux.conf`. To open the usual
window layout (utils, blog, here, todo, llm) inside a new session:

```bash
tmux new -s work
tmux source-file ~/.tmux/work.tmux
```

Model runs go in their own named session so they can be found again after
a disconnect:

```bash
tmux new -s run_reference -d 'cd ~/rp/eu_cbm && python run.py 2>&1 | tee run.log'
tmux attach -t run_reference
```


## 6. Neovim

`~/.config/nvim` is linked to `setup/server/nvim_server`, a minimal config
(vim-slime, fzf, fugitive, aerial, treesitter) written for Debian 13's
Neovim 0.10. On first start, lazy.nvim downloads the plugins and
nvim-treesitter compiles its parsers, which is why `build-essential` is in
the package list.

Two details:

- **`lazy-lock.json` lives in the clone.** lazy.nvim writes plugin versions
  there, so `git status` in `~/rp/paulrougieux` will show it modified after
  a plugin update. `git pull --autostash` handles this. To bring the server
  back to the laptop's pinned versions, run
  `git -C ~/rp/paulrougieux checkout setup/server/nvim_server/lazy-lock.json`
  and then `:Lazy restore` in Neovim.
- **vim-slime** sends lines from Neovim to a REPL in another tmux pane.
  Open `ipython` in one pane and Neovim in the other.


## 7. Git

`~/.gitconfig` sets the name and email, the `lg`, `st` and `amend` aliases,
`pull.rebase = true` and `init.defaultBranch = main`.

For the repositories you *do* push from the server (model code, not the
dotfiles), create a dedicated key and add it to GitLab as a deploy key or
to your account:

```bash
ssh-keygen -t ed25519 -C "$(hostname)"
cat ~/.ssh/id_ed25519.pub
```

Log `glab` in once with `glab auth login`.


## 8. Tools outside apt

These are installed per user in `~/.local`, so they need no root and
follow their own release cycle, faster than Debian's.

```bash
# uv: Python versions and project environments
curl -LsSf https://astral.sh/uv/install.sh | sh

# Claude Code
curl -fsSL https://claude.ai/install.sh | bash

# pipx tools, for example
pipx install yt-dlp
```

The pi coding agent and its Node.js runtime live in
`~/.local/share/pi-node` on the current server. Configure it by linking the
files from the `agents_toolbox` repository:

```bash
git clone https://gitlab.com/paulrougieux/agents_toolbox.git ~/rp/agents_toolbox
mkdir -p ~/.pi/agent && cd ~/.pi/agent
ln -s ~/rp/agents_toolbox/pi_harness/models.json models.json
ln -s ~/rp/agents_toolbox/pi_harness/settings.json settings.json
```

To run pi inside a Docker container per project, see
`containers/README.md` in the `agents_toolbox` repository.


## Checklist

```bash
su -c 'apt update && apt install sudo && usermod -aG sudo paul'  # then log in again
sudo apt install git curl rsync                              # if missing
mkdir -p ~/repos ~/.local/bin && ln -s repos ~/rp
git clone https://gitlab.com/paulrougieux/paulrougieux.git ~/rp/paulrougieux
~/rp/paulrougieux/setup/debian_server/install_apt_packages.sh
~/rp/paulrougieux/setup/debian_server/link_dotfiles.sh
curl -LsSf https://astral.sh/uv/install.sh | sh
exit                                                         # log in again for PATH and docker group
```
