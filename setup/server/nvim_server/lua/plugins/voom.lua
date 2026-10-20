-- VOoM: two-pane outliner used as a table of contents for markdown, R
-- markdown, quarto and LaTeX files. Mirrors the Voom setup in ~/.vimrc.
local toc_filetypes = { "markdown", "rmd", "quarto", "tex", "rnoweb" }

return {
  {
    "vim-voom/VOoM",
    init = function()
      -- Outline with the pandoc mode (atx "#" headings) or the latex mode
      -- (\section), instead of VOoM's default fold markers.
      vim.g.voom_ft_modes = {
        markdown = "pandoc",
        pandoc = "pandoc",
        rmd = "pandoc",
        quarto = "pandoc",
        tex = "latex",
        rnoweb = "latex",
      }
    end,
    config = function()
      -- :Toc opens the outline, matching the ~/.vimrc command.
      -- :TOc is an alias, for when the shift key is held one letter too long.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("Toc", { clear = true }),
        pattern = toc_filetypes,
        callback = function(args)
          vim.api.nvim_buf_create_user_command(args.buf, "Toc", "Voom", {})
          vim.api.nvim_buf_create_user_command(args.buf, "TOc", "Voom", {})
        end,
      })
    end,
  },
}
