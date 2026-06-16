return {
  "nvim-tree/nvim-tree.lua",
  custom_tags = {"lite"},
  config = function()
    require("nvim-tree").setup({
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local open_inplace = function()
          api.node.open.edit()
          api.tree.close()
        end

        api.config.mappings.default_on_attach(bufnr)
        Api.rumap("n", "o", open_inplace, {buffer = bufnr})
      end,
    })
    Api.rumap("n", "<leader>tf", ":NvimTreeFocus<CR>")
    Api.rumap("n", "<leader>tr", ":NvimTreeRefresh<CR>")
    Api.rumap("n", "<leader>tc", ":NvimTreeClose<CR>")
  end
}
