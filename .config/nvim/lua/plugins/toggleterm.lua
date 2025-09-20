return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup {}
    vim.keymap.set("n", "<leader>cc", "<cmd>enew<CR><cmd>terminal<CR>A", {})
  end,
}
