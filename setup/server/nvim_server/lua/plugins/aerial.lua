-- aerial.nvim: symbol outline (classes/methods) in a sidebar. Mirrors the aerial
-- block in ~/.config/nvim. Press F8 on a python file to toggle it on the left.
return {
  "stevearc/aerial.nvim",
  -- master requires Neovim >= 0.12. The flower server runs 0.10.4, so pin the
  -- nvim-0.9 compatibility branch (there is no nvim-0.10 branch; nvim-0.11 needs
  -- Neovim >= 0.11). Bump this if the server's Neovim is upgraded.
  branch = "nvim-0.9",
  opts = {
    -- Determines where the aerial window will be opened
    --   edge   - open aerial at the far right/left of the editor
    --   window - open aerial to the right/left of the current window
    placement = "window",
    -- Width of the sidebar
    width = 30,
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require('aerial').setup({
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
    })
    -- Map F8 to toggle Aerial on the left
    vim.keymap.set('n', '<F8>', '<cmd>AerialToggle left<CR>', { noremap = true, silent = true })
  end,
}
