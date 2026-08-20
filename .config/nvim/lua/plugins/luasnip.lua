return {
  "L3MON4D3/LuaSnip",
  custom_tags = {"lite"},
  config = function()
    require("luasnip.loaders.from_lua").load({paths = "./snippets"})
  end,
}
