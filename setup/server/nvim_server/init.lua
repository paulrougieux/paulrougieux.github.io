-- Minimal, self-contained Neovim config for a server.
-- Only sets up vim-slime for now. Does NOT source ~/.vimrc.
--
-- Run it without touching your main config:
--   nvim -u ~/rp/paulrougieux.github.io/setup/server/nvim_server/init.lua
-- or point XDG at this directory:
--   XDG_CONFIG_HOME=~/rp/paulrougieux.github.io/setup nvim   (dir named "nvim")
--
-- Upload this config to the server "flower" (user paul) with rsync, so it lives
-- at ~/.config/nvim on the server:
--   rsync -av --delete ~/rp/paulrougieux.github.io/setup/server/nvim_server/ paul@flower:~/.config/nvim/
-- The trailing slash on the source copies the directory contents (not the dir
-- itself). --delete removes server files no longer present locally.
--
-- Slime sends text to a live REPL running in another tmux pane. Start nvim in
-- one tmux pane and the REPL (python, ipython, R, ...) in another.

-- Leader keys must be set before lazy.nvim loads so mappings are correct.
-- These match ~/.vimrc.
vim.g.mapleader = ","
vim.g.maplocalleader = ";"

-- New splits open below and to the right (matches ~/.vimrc).
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Window navigation from inside a :terminal buffer, similar to tmux-navigator.
vim.keymap.set("t", "<C-J>", "<C-W><C-J>")
vim.keymap.set("t", "<C-K>", "<C-W><C-K>")
vim.keymap.set("t", "<C-L>", "<C-W><C-L>")
vim.keymap.set("t", "<C-H>", "<C-W><C-H>")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
    { import = "plugins" },
  },
})
