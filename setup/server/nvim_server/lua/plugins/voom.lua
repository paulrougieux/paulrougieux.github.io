-- VOoM: two-pane outliner used as a markdown table of contents.
-- Mirrors the Voom setup in ~/.vimrc, restricted to markdown files.
return {
  {
    "vim-voom/VOoM",
    init = function()
      -- Outline markdown with the pandoc mode (atx "#" headings).
      vim.g.voom_ft_modes = { markdown = "pandoc" }
    end,
    config = function()
      -- :Toc opens the outline, matching the ~/.vimrc command. Markdown only.
      -- :TOc is an alias, for when the shift key is held one letter too long.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          vim.api.nvim_buf_create_user_command(args.buf, "Toc", "Voom", {})
          vim.api.nvim_buf_create_user_command(args.buf, "TOc", "Voom", {})
        end,
      })
    end,
  },
}
