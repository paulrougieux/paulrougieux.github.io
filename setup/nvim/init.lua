-- Prepend ~/.vim and append ~/.vim/after to runtimepath
vim.opt.runtimepath:prepend("~/.vim")
vim.opt.runtimepath:append("~/.vim/after")

-- Set packpath equal to runtimepath
vim.o.packpath = vim.o.runtimepath

-- Source your ~/.vimrc file (Vimscript)
vim.cmd("source ~/.vimrc")

require("config.lazy")


require'nvim-treesitter.configs'.setup {
  ensure_installed = { "lua", "vim", "vimdoc", "query" },  -- add vimdoc here
  highlight = { enable = true },
  auto_install = true,
}





