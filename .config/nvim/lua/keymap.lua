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

  Api.rumap("n", "<leader>dd", "^t]rx")
  Api.rumap("n", "<leader>ds", "^t]r ")

  Api.rumap("i", "<D-Space>", "")  -- fixes GNOME issues
end

return keymap
