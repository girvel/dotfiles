local keymap = {}
keymap.init = function()
  Map("i", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
  end, {remap = true})

  Map("n", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ggO", true, false, true), "n", false)
  end, {remap = true})

  Map("n", "<leader>lr", vim.lsp.buf.rename, {})
  Map("n", "<leader>lf", vim.diagnostic.open_float, {})
  Map("n", "gD", vim.lsp.buf.declaration, {})

  -- shift safety --
  Map("n", ":W", ":w")
end

return keymap
