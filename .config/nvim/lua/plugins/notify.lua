local core = require("core.init")


return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")

    --- @diagnostic disable-next-line
    vim.notify = function(head, ...)
      if head == "" then head = " " end
      return notify(head, ...)
    end

    notify.setup {
      render = "wrapped-compact",
      minimum_width = core.layout.notification.w,
      max_width = core.layout.notification.w,
    }
  end,
}
