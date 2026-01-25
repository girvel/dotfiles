return {
  "aveplen/ruscmd.nvim",
  config = function()
    require("ruscmd").setup {}

    vim.keymap.set("n", "<C-ц>р", "<C-w>h")
    vim.keymap.set("n", "<C-ц>о", "<C-w>j")
    vim.keymap.set("n", "<C-ц>л", "<C-w>k")
    vim.keymap.set("n", "<C-ц>д", "<C-w>l")
    vim.keymap.set("n", "<C-ц>м", "<C-w>v")
    vim.keymap.set("n", "<C-ц>ы", "<C-w>s")

    vim.cmd.cnoreabbrev("цй wq")
    vim.cmd.cnoreabbrev("цф wa")
    vim.cmd.cnoreabbrev("цйф wqa")
  end,
}
