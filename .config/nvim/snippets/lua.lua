local get_head = function(path)
  return select(3, string.find(path, "%.?([^%.]*)$"))
end

local lua_path = function(posix_path)
  return posix_path
    :gsub("/mnt/d/workshop/engine/", "")
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
  s("mon", {
    t("local "),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
    t({" = {}", "", "--- @class "}),
    i(1),
    t({"", "local methods = {}", ""}),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
    t({".mt = {__index = methods}", "", "--- @return "}),
    f(function(args) return args[1][1] end, 1),
    t({"", ""}),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
    t({".new = function()", "  return setmetatable({", "    "}),
    i(2),
    t({"", "  }, "}),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
    t({".mt)", "end"}),
    i(0),
    t({"", "", "Ldump.mark("}),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
    t({', {mt = "const"}, ...)', "return "}),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
  }),
  s("mo", {
    t("local "),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
    t({" = {}", ""}),
    i(0),
    t({"", "Ldump.mark("}),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
    t({", {}, ...)", "return "}),
    f(function(args) return get_head(lua_path(vim.api.nvim_buf_get_name(0))) end),
  }),
}
