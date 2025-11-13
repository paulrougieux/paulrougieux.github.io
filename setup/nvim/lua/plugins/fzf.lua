return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "nvim-mini/mini.icons" },
  opts = {},
  config = function()
    require('fzf-lua').setup({
      -- your fzf-lua settings here if any
    })
    vim.keymap.set('n', '<leader>ff', require('fzf-lua').files, { desc = 'Fzf files' })
    vim.keymap.set('n', '<leader>fg', require('fzf-lua').live_grep, { desc = 'Fzf live grep' })
    vim.keymap.set('n', '<leader>fw', require('fzf-lua').grep_cword, { desc = 'Fzf live grep word' })
  end
}
