return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local nts = require('nvim-treesitter')
      local wanted = {
        "lua", "vim", "vimdoc", "query",
        "r", "python", "bash",
        "javascript", "typescript", "html", "css",
        "json", "yaml", "toml",
        "markdown", "markdown_inline",
        "latex", "bibtex",
        "sql", "dockerfile",
        "gitcommit", "gitignore", "git_rebase", "diff",
        "regex",
      }
      local installed = nts.get_installed and nts.get_installed("parsers") or {}
      local missing = {}
      for _, p in ipairs(wanted) do
        if not vim.tbl_contains(installed, p) then
          table.insert(missing, p)
        end
      end
      if #missing > 0 then nts.install(missing) end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and pcall(vim.treesitter.language.add, lang) then
            pcall(vim.treesitter.start)
          end
        end,
      })
    end,
  },
}



