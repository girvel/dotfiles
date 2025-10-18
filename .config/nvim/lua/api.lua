local api = {}

--- @param sequence string
api.feed = function(sequence)
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(sequence, true, false, true),
    "n", false
  )
end

--- @param file_path string
--- @return string
api.luapath = function(file_path)
  -- (multiple return values)
  local result = file_path:gsub("^%./", ""):gsub("%.lua$", ""):gsub("[/\\]", ".")
  return result
end

--- @param modpath string
--- @return string
api.luapath_head = function(modpath)
  local head = modpath:match("%.([^%.]+)$")
  return head or modpath
end

api.rumap = require("api.rumap")

return api
