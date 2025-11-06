local keymap = {}
keymap.init = function()
  Api.rumap("i", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
  end, {remap = true})

  Api.rumap("n", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ggO", true, false, true), "n", false)
  end, {remap = true})

  Api.rumap("n", "<leader>lr", vim.lsp.buf.rename, {})
  Api.rumap("n", "<leader>lf", vim.diagnostic.open_float, {})
  Api.rumap("n", "gD", vim.lsp.buf.declaration, {})

  Api.rumap("i", "<C-o>", "<Esc><C-o>", {})
  Api.rumap("i", "<C-i>", "<Esc><C-i>", {})
  Api.rumap("v", "<C-o>", "<Esc><C-o>", {})
  Api.rumap("v", "<C-i>", "<Esc><C-i>", {})
end

return keymap
