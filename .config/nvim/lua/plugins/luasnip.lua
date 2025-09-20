return {
  "L3MON4D3/LuaSnip",
  config = function()
    require("luasnip.loaders.from_lua").load({paths = "./snippets"})
    local luasnip = require("luasnip")
    Map("i", "<M-CR>", function() luasnip.jump(1) end, {silent = true})
  end,
}
