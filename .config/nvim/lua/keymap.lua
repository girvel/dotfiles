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
  Api.rumap("n", "<leader>le", ":LspStart<CR>", {desc = "Start (enable) LSP"})
  Api.rumap("n", "<leader>ld", ":LspStop<CR>", {desc = "Stop (disable) LSP"})
  Api.rumap("n", "<leader>ls", ":LspRestart<CR>", {desc = "Stop (disable) LSP"})
  Api.rumap("n", "gD", vim.lsp.buf.declaration, {})

  Api.rumap("n", "<leader>dd", "^t]rx", {desc = "Complete markdown task"})
  Api.rumap("n", "<leader>ds", "^t]r ", {desc = "Uncomplete markdown task"})

  Api.rumap("i", "<D-Space>", "", {desc = "Empty action to fix GNOME issues"})

  Api.rumap("n", "<leader>gf", function()
    local dir = vim.fn.expand("%:p:h")
    local file = vim.fn.expand("<cWORD>")
    vim.cmd.edit(dir .. "/" .. file)
  end, {desc = "Go to file even if it does not exist"})

  Api.rumap("v", "<C-j>", ":m '>+<C-r>=v:count1<CR><CR>gv", {desc = "Move selection down"})
  Api.rumap("v", "<C-k>", ":m '<-<C-r>=v:count1+1<CR><CR>gv", {desc = "Move selection up"})

  Api.rumap("v", "<C-h>", "<'<V'>", {desc = "Dedent while preserving visual mode"})
  Api.rumap("v", "<C-l>", ">'<V'>", {desc = "Indent while preserving visual mode"})

  Api.rumap("n", "]e", function() vim.diagnostic.jump {count = 1} end, {desc = "Next error"})
  Api.rumap("n", "[e", function() vim.diagnostic.jump {count = -1} end, {desc = "Prev error"})
end

return keymap
