return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup {}
    Api.rumap("n", "<leader>cc", "<cmd>enew<CR><cmd>terminal<CR>A", {})
    -- Api.rumap("n", "<leader>cf", ":ToggleTerm direction=float<CR>")
    -- Api.rumap("n", "<leader>cv", ":ToggleTerm direction=vertical size=80<CR>")
    -- Api.rumap("n", "<leader>ch", ":ToggleTerm direction=horizontal size=15<CR>")

    _G.set_terminal_keymaps = function()
      Api.rumap("t", "<esc>", "<C-\\><C-n>")
      Api.rumap('t', '<C-w>', "<C-\\><C-n><C-w>")
    end
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
