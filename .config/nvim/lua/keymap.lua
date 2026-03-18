local keymap = {}

keymap.init = function()
  Api.rumap("i", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
  end, {desc = "Newline at the beginning of the file", remap = true})

  Api.rumap("n", "<M-o>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ggO", true, false, true), "n", false)
  end, {desc = "Newline at the beginning of the file", remap = true})

  Api.rumap("n", "<leader>lr", vim.lsp.buf.rename, {desc = "LSP rename variable"})
  Api.rumap("n", "<leader>lf", vim.diagnostic.open_float, {desc = "LSP see warning"})
  Api.rumap("n", "gD", vim.lsp.buf.declaration, {})

  Api.rumap("n", "<leader>dd", "^t]rx", {desc = "Complete markdown task"})
  Api.rumap("n", "<leader>ds", "^t]r ", {desc = "Uncomplete markdown task"})

  Api.rumap("i", "<D-Space>", "", {desc = "Empty action to fix GNOME issues"})
end

return keymap
