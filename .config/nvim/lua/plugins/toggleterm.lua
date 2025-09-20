return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup {}
    Map("n", "<leader>cc", "<cmd>enew<CR><cmd>terminal<CR>A", {})
    -- Map("n", "<leader>cf", ":ToggleTerm direction=float<CR>")
    -- Map("n", "<leader>cv", ":ToggleTerm direction=vertical size=80<CR>")
    -- Map("n", "<leader>ch", ":ToggleTerm direction=horizontal size=15<CR>")

    _G.set_terminal_keymaps = function()
      Map("t", "<esc>", "<C-\\><C-n>")
      Map('t', '<C-w>', "<C-\\><C-n><C-w>")
    end
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
