local qwerty = require("lib.qwerty")


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

local ruscmd_collisions = {
  ZZ = true,
  gd = true,
}

--- vim.keymap.set but supporting russian layout & async functions
--- @param mode string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
--- @param lhs string           Left-hand side |{lhs}| of the mapping.
--- @param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
--- @param opts? vim.keymap.set.Opts
api.rumap = function(mode, lhs, rhs, opts)
  if type(rhs) == "function" then
    rhs = Async.make(rhs)
  end

  vim.keymap.set(mode, lhs, rhs, opts)
  if ruscmd_collisions[lhs] then return end
  vim.keymap.set(mode, qwerty.translate(lhs), rhs, opts)
end

return api
