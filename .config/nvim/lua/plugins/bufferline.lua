return {
  "akinsho/bufferline.nvim",
  dependencies = "nvim-tree/nvim-web-devicons",
  opts = {
    options = {
      separator_style = "slant",
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
        {
          filetype = "snacks_layout_box",
        },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)

    for _, mode in ipairs {"n", "t", "i"} do
      local prefix = mode == "n" and "" or "<Esc>"
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
    Map("n", "<leader>bc", "<cmd>w<CR><cmd>bdelete<CR><cmd>bprev<CR>", {})
  end,
}
