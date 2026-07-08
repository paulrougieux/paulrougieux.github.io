-- nvim-treesitter for the server. Provides the parsers aerial's treesitter
-- backend needs to show the class/method outline (F8).
--
-- NOTE: the laptop config uses the `main` branch, which requires Neovim >= 0.11
-- and a different API (nts.install). The flower server runs 0.10.4, so this uses
-- the classic `master` branch with the nvim-treesitter.configs API instead.
-- Parser compilation needs a C compiler on the server (gcc/cc + make).
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'master',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      ensure_installed = {
        "python", "lua", "bash", "r",
        "markdown", "markdown_inline",
        "json", "yaml", "toml",
      },
      highlight = { enable = true },
    })
  end,
}
