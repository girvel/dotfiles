return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  config = function(_, opts)
    local gitsigns = require("gitsigns")
    gitsigns.setup(opts)

    -- gitsigns' refresh does not work by default
    vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
      pattern = "*",
      callback = function(args)
        vim.schedule(function()
          gitsigns.detach(args.buf)
          gitsigns.attach(args.buf)
        end)
      end,
    })
  end,
}
