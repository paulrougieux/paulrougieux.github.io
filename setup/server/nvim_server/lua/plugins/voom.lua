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
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          vim.api.nvim_buf_create_user_command(args.buf, "Toc", "Voom", {})
        end,
      })
    end,
  },
}
