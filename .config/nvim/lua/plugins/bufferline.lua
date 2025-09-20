return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup {
      options = {
        separator_style = "slant",
      },
    }

    Map("n", "ZZ", "<cmd>w<CR><cmd>bdelete<CR><cmd>bprev<CR>", {})
    for _, mode in ipairs {"n", "t"} do
      local prefix = mode == "t" and "<Esc>" or ""
      for _, keypair in ipairs {{"Left", "Right"}, {"h", "l"}} do
        local left, right = unpack(keypair)
        Map(mode, "<C-" .. left .. ">",  prefix .. "<cmd>BufferLineCyclePrev<CR>", {})
        Map(mode, "<C-" .. right .. ">", prefix .. "<cmd>BufferLineCycleNext<CR>", {})
      end
    end

    Map("n", "<leader>bl", "<cmd>BufferLineCloseRight<CR>", {})
    Map("n", "<leader>bh", "<cmd>BufferLineCloseLeft<CR>", {})
    Map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", {})
    Map("n", "<leader>bb", "<cmd>BufferLineGoToBuffer 1<CR>", {})
  end,
}
