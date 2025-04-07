local get_head = function(path)
  return select(3, string.find(path, "%.?([^%.]*)$"))
end

local lua_path = function(posix_path)
  return posix_path
    :gsub("/mnt/d/workshop/fallen/", "")
    :gsub("%.([^%.]*)$", "")
    :gsub("/", ".")
end

return {
  s("re", {
    t("local "),
    f(function(args) return get_head(args[1][1]) end, 1),
    t(' = require("'),
    i(1),
    t('")'),
    i(0),
  }),
  s("mo",
    fmt('local {}, module_mt, static = Module("{}")', {
      f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
      f(function(args) return lua_path(vim.api.nvim_buf_get_name(0)) end)
    })
  ),
  s("mor",
    fmt('local {module}, module_mt, static = Module("{}")\n\n{}\n\nreturn {module}', {
      module = f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
      f(function(args) return lua_path(vim.api.nvim_buf_get_name(0)) end),
      i(0),
    })
  ),
}
