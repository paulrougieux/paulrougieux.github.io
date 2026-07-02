-- Slime sends text to a live Read Eval Print Loop
return {
  {
    "jpalardy/vim-slime",
    init = function()
      -- use tmux with slime
      vim.g.slime_target = "tmux"
      -- vim in a split tmux window with a REPL in the other pane
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{last}" }
      -- https://github.com/jpalardy/vim-slime/issues/131
      vim.g.slime_python_ipython = 1
    end,
    config = function()
      -- Keybindings mirror those in ~/.vimrc (localleader is ";")
      local function map_slime(ft)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = ft,
          callback = function(args)
            local opts = { buffer = args.buf }
            -- send the current line
            vim.keymap.set("n", "<LocalLeader>l", "<Plug>SlimeLineSend", opts)
            -- send the current paragraph
            vim.keymap.set("n", "<LocalLeader>p", "<Plug>SlimeParagraphSend", opts)
            -- send the visual selection
            vim.keymap.set("x", "<LocalLeader>m", "<Plug>SlimeRegionSend", opts)
            -- send the word under the cursor
            vim.keymap.set("n", "<LocalLeader>w", "viw<Plug>SlimeRegionSend", opts)
          end,
        })
      end
      map_slime({ "python", "markdown" })
    end,
  },
}
