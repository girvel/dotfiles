local keymap = {}
keymap.init = function()
  vim.keymap.set("i", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
  end, {remap = true})

  vim.keymap.set("n", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ggO", true, false, true), "n", false)
  end, {remap = true})

  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})
  vim.keymap.set("n", "<leader>lf", vim.diagnostic.open_float, {})
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})

  -- shift safety --
  vim.keymap.set("n", ":W", ":w")
end

return keymap
