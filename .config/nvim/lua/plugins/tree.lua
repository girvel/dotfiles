return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({})
    Map("n", "<leader>tf", ":NvimTreeFocus<CR>")
    Map("n", "<leader>tr", ":NvimTreeRefresh<CR>")
  end
}
