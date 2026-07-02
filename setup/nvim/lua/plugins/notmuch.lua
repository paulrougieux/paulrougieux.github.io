-- notmuch mail interface
-- Run :Notmuch to open the saved-searches view
return {
  {
    "felipec/notmuch-vim",
    cmd = { "NotMuch", "NotMuchMail", "NotMuchCompose" },
    init = function()
      -- Default folders / saved searches shown on :Notmuch
      vim.g.notmuch_folders = {
        { "inbox",        "tag:inbox" },
        { "unread",       "tag:unread" },
        { "attachments",  "tag:attachment" },
        { "deleted",      "tag:deleted" },
        -- French employment contracts with attachments, 2009–2018
        -- Avoid apostrophes here: the plugin wraps the query in single
        -- quotes when invoking s:search, so any inner ' breaks parsing.
        { "contracts-fr", "date:2009..2018 and tag:attachment and "
          .. "(contrat OR embauche OR CDI OR CDD OR avenant OR engagement)" },
      }

      -- Use system sendmail; tweak if you wire up msmtp/etc later
      vim.g.notmuch_sendmail = "sendmail"

      -- Extra keymaps merged into the plugin defaults (see set_defaults()
      -- in plugin/notmuch.vim, which extends these dicts). Values are bare
      -- function calls, same format as the built-in maps.
      -- 'd' = tag the thread/message +deleted with no prompt (built-in 't'
      -- still works and prompts for an arbitrary tag).
      -- Chain a search_refresh() after tagging so the line disappears from
      -- the list immediately (the -inbox drops it out of the tag:inbox query).
      -- set_map() prepends <SID> and appends <CR>, and nnoremap expands every
      -- <SID>/<bar> in the RHS, so the two :call commands both resolve.
      vim.g.notmuch_custom_search_maps = {
        d = 'search_tag("+deleted -inbox -unread") <bar> call <SID>search_refresh()',
      }
      vim.g.notmuch_custom_show_maps = {
        d = 'show_tag("+deleted -inbox -unread")',
      }
    end,
  },
}
