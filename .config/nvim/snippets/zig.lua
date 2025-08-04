local get_head = function(path)
  if path == nil then return "" end
  local i = path:find("/[^/]+$")
  if i then
    path = path:sub(i + 1)
  end
  if vim.endswith(path, ".zig") then
    path = path:sub(1, #path - 4)
  end
  print(tostring(path))
  return path
end

return {
  s("re", {
    t("const "),
    f(function(args) return get_head(args[1][1]) end, 1),
    t(' = @import("'),
    i(1),
    t('");'),
    i(0),
  }),
}
