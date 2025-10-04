return {
  "loctvl842/monokai-pro.nvim",
  opts = {
    filter = "spectrum",
    background_clear = {
      "telescope",
      "notify",
    },
    plugins = {
      underline_selected = true,
    },
  },
  config = function(_, opts)
    if vim.env.TERM == "linux" then return end

    require("monokai-pro").setup(opts)
    vim.cmd.colorscheme("monokai-pro")
  end
}
