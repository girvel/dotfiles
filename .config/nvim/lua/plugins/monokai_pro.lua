local THEME = "spectrum"

return {
  "loctvl842/monokai-pro.nvim",
  opts = {
    filter = THEME,
    background_clear = {
      "telescope",
      "notify",
    },
  },
  config = function(_, opts)
    if vim.env.TERM == "linux" then return end
    local monokai = require("monokai-pro")

    monokai.setup(opts)
    vim.cmd.colorscheme("monokai-pro")

    local palette = require("monokai-pro.palette." .. THEME)
    vim.api.nvim_set_hl(0, "LspPreview", { bg = palette.dark1 })
    vim.api.nvim_set_hl(0, "LspPreviewBorder", { bg = palette.dark1, fg = palette.dimmed2 })
    vim.api.nvim_set_hl(0, "NoicePopup", { link = "LspPreview" })
    vim.api.nvim_set_hl(0, "NoicePopupBorder", { link = "LspPreviewBorder" })
  end
}
