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

api.async = function(f)
  return function(...)
    coroutine.resume(coroutine.create(f), ...)
  end
end

-- NEXT use resume
api.await = function(f, ...)
  local current = coroutine.running()
  assert(current ~= nil, "api.await should be called from the coroutine; see Api.async")

  local result = nil
  local args = {}
  local callback_arg_specified = false

  local callback = function(...)
    result = {...}
    if coroutine.status(current) == "suspended" then
      coroutine.resume(current)
    end
  end

  for i = 1, select("#", ...) do
    local arg = select(i, ...)
    if arg == api.callback_here then
      callback_arg_specified = true
      arg = callback
    end
    args[i] = arg
  end

  if callback_arg_specified then
    f(unpack(args))
  else
    f(callback, unpack(args))
  end

  if result == nil then
    coroutine.yield()
  end  --- @cast result table

  return unpack(result)
end

api.callback_here = {}

api.step = function() api.await(vim.schedule) end
api.sleep = function(ms) api.await(vim.defer_fn, ms) end

api.resume = function(f)
  local current = coroutine.running()
  assert(current ~= nil, "api.await should be called from the coroutine; see Api.async")
  return function(...)
    if coroutine.status(current) == "suspended" then
      local result
      if f then
        result = {coroutine.resume(current, f(...))}
      else
        result = {coroutine.resume(current, ...)}
      end
      table.remove(result, 1)
      return result
    end

    return f(...)
  end
end

return api
