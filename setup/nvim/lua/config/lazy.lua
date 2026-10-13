-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- leader keys are defied in .vimrc sourced by nvim/init.lua
-- Redefine them here?
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = ";"


-- Added by Paul
-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import plugins
    { import = "plugins" },

    -- Colour theme
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

    -- Slime sends text to a live Read Eval Print Loop
    {
      "jpalardy/vim-slime",
    },

    -- Navigate between vim splits and tmux panes
    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
        "TmuxNavigatorProcessList",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    },

    -- Git interface
    {
      "tpope/vim-fugitive",
      cmd = { "Git", "G", "Gwrite", "Gread", "Gdiffsplit" },
      keys = {
          { "<leader>g", "<cmd>belowright Git<cr>", desc = "Git status (below)" },
      },
    },
    "tpope/vim-dispatch",

    -- Markdown table of contents
    {
      "vim-voom/VOoM",
      ft = { "markdown", "rmd", "quarto", "rnoweb" },
      config = function()
        -- Create a Toc command for each filetype
        local augroup = vim.api.nvim_create_augroup("Toc", { clear = true })
        
        vim.api.nvim_create_autocmd("FileType", {
          group = augroup,
          pattern = { "markdown", "rmd", "quarto", "rnoweb" },
          callback = function()
            vim.api.nvim_buf_create_user_command(0, "Toc", "Voom", {})
          end,
        })
      end,
    },

    -- Python methods table of contents
    {
      'stevearc/aerial.nvim',
      opts = {
          -- Determines where the aerial window will be opened
          --   edge   - open aerial at the far right/left of the editor
          --   window - open aerial to the right/left of the current window
          placement = "window",
          -- Optional: specify the width of the sidebar
          width = 30,
      },
      -- Optional dependencies
      dependencies = {
         "nvim-treesitter/nvim-treesitter",
         "nvim-tree/nvim-web-devicons"
      },
      config = function()
          require('aerial').setup({
              backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
          })
          -- Map F8 to toggle Aerial
          vim.keymap.set('n', '<F8>', '<cmd>AerialToggle left<CR>', { noremap = true, silent = true })
      end,
    },

    -- Tabular, line up text in tables, :TT on a markdown table
    {
      "godlygeek/tabular",
      -- Load at startup, the command below is defined in config
      lazy = false,
      keys = {
        -- Align the table under the cursor, no need to select it first
        { "<leader>ta", "<cmd>TT<cr>", desc = "Align markdown table" },
        -- Align the visual selection
        { "<leader>ta", ":TT<cr>", mode = "v", desc = "Align markdown table" },
      },
      config = function()
        -- :TT tabularizes tables made with a pipe. It is :Tabularize /|
        -- without the space Tabular adds in front of the leading pipe.
        -- Without a range, Tabular extends the current line to the adjacent
        -- lines containing a pipe, extend the same way to remove the spaces.
        vim.api.nvim_create_user_command("TT", function(args)
          local first, last = args.line1, args.line2
          vim.cmd(first .. "," .. last .. "Tabularize /|")
          if args.range == 0 then
            local has_pipe = function(lnum)
              return vim.fn.getline(lnum):find("|", 1, true) ~= nil
            end
            while first > 1 and has_pipe(first - 1) do first = first - 1 end
            while last < vim.fn.line("$") and has_pipe(last + 1) do last = last + 1 end
          end
          vim.cmd(first .. "," .. last .. [[substitute/^\s\+|/|/e]])
          vim.cmd("nohlsearch")
        end, { range = true, desc = "Align a markdown table" })
      end,
    },

    -- Python linter
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
  }
)


