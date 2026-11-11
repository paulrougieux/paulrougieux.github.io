-- Prepend ~/.vim and append ~/.vim/after to runtimepath
-- vim.opt.runtimepath:prepend("~/.vim")
-- vim.opt.runtimepath:append("~/.vim/after")

-- Set packpath equal to runtimepath
-- vim.o.packpath = vim.o.runtimepath

-- Source your ~/.vimrc file (Vimscript)
vim.cmd("source ~/.vimrc")

-- TODO figure out the error
vim.g.python3_host_prog = "/home/paul/rp/penv/bin/python3"

require("config.lazy")

-- In netrw, make gx behave like netrw's own `x` (open with the system viewer).
-- This is only to satisfy my muscle memory of gx from normal buffers: the
-- default gx (vim.ui.open) passes the bare filename to xdg-open, which fails in
-- tree listings for files in subdirectories, while `x` resolves the full path.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function(ev)
    vim.keymap.set("n", "gx", "x", { buffer = ev.buf, remap = true, desc = "netrw: open with system viewer (x)" })
  end,
})


