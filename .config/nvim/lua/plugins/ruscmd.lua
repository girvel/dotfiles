return {
  "aveplen/ruscmd.nvim",
  config = function()
    local oldmap = vim.api.nvim_set_keymap
    vim.api.nvim_set_keymap = function(mode, lhs, rhs, opts)  --- @diagnostic disable-line
      if vim.fn.maparg(lhs, mode) == "" then
        oldmap(mode, lhs, rhs, opts)
      end
    end
    require("ruscmd").setup {}
    vim.api.nvim_set_keymap = oldmap

    vim.keymap.set("n", "<C-ц>р", "<C-w>h")
    vim.keymap.set("n", "<C-ц>о", "<C-w>j")
    vim.keymap.set("n", "<C-ц>л", "<C-w>k")
    vim.keymap.set("n", "<C-ц>д", "<C-w>l")
    vim.keymap.set("n", "<C-ц>м", "<C-w>v")
    vim.keymap.set("n", "<C-ц>ы", "<C-w>s")
    vim.keymap.set("n", "<C-м>", "<C-v>")
    vim.keymap.set("n", "<C-S-м>", '"+p')

    vim.cmd.cnoreabbrev("цй wq")
    vim.cmd.cnoreabbrev("цф wa")
    vim.cmd.cnoreabbrev("цйф wqa")
  end,
}
