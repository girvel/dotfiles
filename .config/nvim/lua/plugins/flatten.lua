return {
  "willothy/flatten.nvim",
  config = function()
    require("flatten").setup {}
    Api.rumap("ca", "wqa", "wa | qa", {desc = "Write all files & quit; overloaded for flatten compatibility"})
  end,
  lazy = false,
}
