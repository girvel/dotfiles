-- TODO Api global object?
Map = require("rumap")

--- @param sequence string
Feed = function(sequence)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(sequence, true, false, true),
    "n", false
  )
end

require("opt").init()
require("package_manager").init()
require("snippets").init()
require("keymap").init()
require("neovide").init()
