return {
  {
    'mason-org/mason.nvim',
    opts = {},
  },
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { "lua_ls", "pyright" },
      automatic_enable = false,
      handlers = {
        -- Default handler for any server
        function(server_name)
          local lspconfig = require('lspconfig')
          local capabilities = require('blink.cmp').get_lsp_capabilities()
          lspconfig[server_name].setup({ capabilities = capabilities })
        end,
        -- Custom lua_ls handler
        lua_ls = function()
          local lspconfig = require('lspconfig')
          local capabilities = require('blink.cmp').get_lsp_capabilities()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                },
              },
            },
          })
        end,
      },
    },
    dependencies = { 'mason-org/mason.nvim', 'neovim/nvim-lspconfig', 'saghen/blink.cmp' },
  }
}

