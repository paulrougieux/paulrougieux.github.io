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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Added by Paul
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },

    -- Colour theme
    {
      "nanotech/jellybeans.vim",
      priority = 1000,
    },

    -- Slime send text to a live Read Eval Print Loop
    {
      "jpalardy/vim-slime",
    },

    -- Git interface
    {
      "tpope/vim-fugitive",
      cmd = { "Git", "G", "Gwrite", "Gread", "Gdiffsplit" },
    },
    "tpope/vim-dispatch",

    -- Markdown table of contents
    {
      "vim-voom/VOoM",
      ft = "markdown",
    },

    -- Python linter
    {
      "dense-analysis/ale",
      event = { "BufReadPre", "BufNewFile" },
      config = function()
        -- Add your ALE configuration here if needed
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})


require("lazy").setup({
})
