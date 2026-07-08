-- Colour theme, matches the laptop config (setup/nvim/lua/config/lazy.lua)
return {
  {
    "nanotech/jellybeans.vim",
    priority = 1000,
    config = function()
      vim.g.jellybeans_overrides = {
        background = { guibg = "303030" },
        signcolumn = { guibg = "000000" },
      }
      vim.cmd.colorscheme("jellybeans")
    end,
  },
}
