return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup {
      options = {
        separator_style = "slant",
      },
    }

    vim.keymap.set("n", "ZZ", "<cmd>w<CR><cmd>bdelete<CR><cmd>bprev<CR>", {})
    for _, mode in ipairs {"n", "t"} do
      local prefix = mode == "t" and "<Esc>" or ""
      for _, keypair in ipairs {{"Left", "Right"}, {"h", "l"}} do
        local left, right = unpack(keypair)
        vim.keymap.set(mode, "<C-" .. left .. ">",  prefix .. "<cmd>bprev<CR>", {})
        vim.keymap.set(mode, "<C-" .. right .. ">", prefix .. "<cmd>bnext<CR>", {})
      end
    end
  end,
}
