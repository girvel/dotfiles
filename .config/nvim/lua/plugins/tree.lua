return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({})
    Api.rumap("n", "<leader>tf", ":NvimTreeFocus<CR>")
    Api.rumap("n", "<leader>tr", ":NvimTreeRefresh<CR>")
    Api.rumap("n", "<leader>tc", ":NvimTreeClose<CR>")
  end
}
