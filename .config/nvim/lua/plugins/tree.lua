return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    require("nvim-tree").setup({})
    vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>")
    vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>")
  end
}
