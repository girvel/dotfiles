Api = require("api.api")
Ui = require("api.ui")
Async = require("api.async")
Config = {
  is_typewriter = os.getenv("TYPEWRITER") ~= nil,
}

require("opt").init()
require("keymap").init()
require("package_manager").init()
require("neovide").init()
require("safety").init()

local open_main_terminal = Async.make(function()
  vim.cmd("enew | terminal")
  Async.step()
  local buf = vim.api.nvim_get_current_buf()
  Api.rumap("n", "<Esc>", "<cmd>b #<cr>", {buffer = buf})
end)

Api.rumap("n", "<leader>cc", function()
  if vim.bo.buftype == "terminal" then return end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end
  open_main_terminal()
end)

_G.set_terminal_keymaps = function()
  Api.rumap("t", "<Esc>", "<C-\\><C-n>")
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

if #vim.fn.argv() == 0 then
  open_main_terminal()
end

if Config.is_typewriter then return end

require("lsp.lua_ls").wrap_diagnostics()
require("snippets").init()
