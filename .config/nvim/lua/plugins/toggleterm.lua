return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup {}
    vim.keymap.set("n", "<leader>cc", "<cmd>enew<CR><cmd>terminal<CR>A", {})
    -- vim.keymap.set("n", "<leader>cf", ":ToggleTerm direction=float<CR>")
    -- vim.keymap.set("n", "<leader>cv", ":ToggleTerm direction=vertical size=80<CR>")
    -- vim.keymap.set("n", "<leader>ch", ":ToggleTerm direction=horizontal size=15<CR>")

    _G.set_terminal_keymaps = function()
      vim.keymap.set("t", "<esc>", "<C-\\><C-n>")
      vim.keymap.set('t', '<C-w>', "<C-\\><C-n><C-w>")
    end
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
