local open_main_terminal = Async.make(function()
  vim.cmd("enew | terminal")
  Async.step()
  local buf = vim.api.nvim_get_current_buf()
  Api.rumap("n", "<Esc>", "<cmd>b #<cr>", {buffer = buf})
end)

Api.rumap("n", "<leader>cn", "<cmd>enew<CR><cmd>terminal<CR>", {})
Api.rumap("n", "<leader>cc", function()
  if vim.bo.buftype == "terminal" then return end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_buf(buf)
      vim.bo[buf].buflisted = true
      return
    end
  end
  open_main_terminal()
end)

_G.set_terminal_keymaps = function()
  Api.rumap("t", "<Esc>", "<C-\\><C-n>")
  vim.opt_local.relativenumber = true
  vim.opt_local.number = true
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

if #vim.fn.argv() == 0 then
  open_main_terminal()
end

