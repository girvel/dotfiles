return {
  "loctvl842/monokai-pro.nvim",
  config = function()
    if vim.env.TERM == "linux" then return end

    require("monokai-pro").setup {
      filter = "spectrum",
    }
    vim.cmd.colorscheme("monokai-pro")
  end
}
