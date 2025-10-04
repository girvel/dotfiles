local luals_fix = {}

luals_fix.feed = function()
  local files = vim.fn.globpath(".", "**/*.lua", true, true)
  local counter = 0
  for _, path in ipairs(files) do
    path = vim.fn.fnamemodify(path, ":p")
    local n = vim.fn.bufadd(path)
    if vim.fn.bufloaded(n) == 0 then
      vim.fn.bufload(n)
      vim.bo[n].buflisted = false
      counter = counter + 1
    end
  end

  if #files > 0 then
    vim.notify(("LuaLS fix: loaded %s files"):format(counter))
  end
end

return luals_fix
