return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup {
      options = {
        separator_style = "slant",
      },
    }

    vim.keymap.set("n", "ZZ", "<cmd>w<CR><cmd>bdelete<CR><cmd>bprev<CR>", {})
    vim.keymap.set("n", "<C-Left>", "<cmd>bprev<CR>", {})
    vim.keymap.set("n", "<C-Right>", "<cmd>bnext<CR>", {})
  end,
}
