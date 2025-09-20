return {
  "rcarriga/nvim-notify",
  config = function()
    vim.notify = require("notify")  --[[@as table]]
    vim.notify.setup {
      render = "wrapped-compact",
      minimum_width = 35,
      max_width = 35,
    }
  end,
}
