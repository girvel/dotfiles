local async = {}
async.make = function(f)
  return function(...)
    local ok, res = coroutine.resume(coroutine.create(f), ...)
    if not ok then
      error(res, 1)
    end
  end
end

async.await = function(f, ...)
  local result = nil
  local args = {}
  local callback_arg_i = 0

  local callback = Async.resume(function(...)
    result = {...}
  end)

  for i = 1, select("#", ...) do
    local arg = select(i, ...)
    if arg == async.callback_here then
      callback_arg_i = i
    end
    args[i] = arg
  end

  if callback_arg_i == 0 then
    table.insert(args, 1, callback)
  else
    args[callback_arg_i] = callback
  end

  f(unpack(args))

  if result == nil then
    coroutine.yield()
  end  --- @cast result table

  return unpack(result)
end

async.callback_here = {}

async.step = function() async.await(vim.schedule) end
async.sleep = function(ms) async.await(vim.defer_fn, ms) end

async.resume = function(f)
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
      local ok = table.remove(result, 1)
      if not ok then
        error(result[1], 1)
      end
      return unpack(result)
    end

    return f(...)
  end
end

return async
