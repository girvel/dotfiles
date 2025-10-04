return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {char = "┊", highlight = "IblIndent1"},
    scope = {char = "┋", highlight = "IblScope1"},
  },
  config = function(_, opts)
    vim.api.nvim_set_hl(0, "IblIndent1", { fg = "#363537" })
    vim.api.nvim_set_hl(0, "IblScope1",  { fg = "#525053" })
    require("ibl").setup(opts)
  end,
}
