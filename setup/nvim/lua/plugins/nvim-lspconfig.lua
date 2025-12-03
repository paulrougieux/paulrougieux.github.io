return {
  {
    -- Paul copied from the blink documentation
    -- https://cmp.saghen.dev/installation#lazy.nvim
    'neovim/nvim-lspconfig',
    dependencies = { 'saghen/blink.cmp' },

    -- example using `opts` for defining servers
    opts = {
      servers = {
        lua_ls = {},
        pyright = {},  -- Add for Python
        -- ruff_lsp = {}, -- Optional: Python linter
      }
    },
    config = function(_, opts)
      local lspconfig = require('lspconfig')
      for server, config in pairs(opts.servers) do
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end
    end,
  }
}

