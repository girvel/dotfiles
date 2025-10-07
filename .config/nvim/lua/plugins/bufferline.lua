local luals_fix = require "luals_fix"
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

    Map("n", "<leader>bl", function()
      vim.cmd("BufferLineCloseRight")
      vim.schedule(function() luals_fix.feed(true) end)
    end, {})

    Map("n", "<leader>bh", function()
      vim.cmd("BufferLineCloseLeft")
      vim.schedule(function() luals_fix.feed(true) end)
    end, {})

    Map("n", "<leader>bo", function()
      vim.cmd("BufferLineCloseOthers")
      vim.schedule(function() luals_fix.feed(true) end)
    end, {})

    Map("n", "<leader>bc", function()
      local listed_buffers = vim.tbl_filter(function(n)
        return vim.api.nvim_buf_is_loaded(n) and vim.bo[n].buflisted
      end, vim.api.nvim_list_bufs())

      vim.bo.buflisted = false
      if #listed_buffers == 1 then
        vim.cmd("enew")
      else
        vim.cmd("b#")
      end
    end, {})
  end,
}
