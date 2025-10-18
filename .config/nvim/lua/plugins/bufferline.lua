local lua_ls = require("lsp.lua_ls")


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
        Api.rumap(mode, "<C-" .. left .. ">",  prefix .. "<cmd>BufferLineCyclePrev<CR>", {})
        Api.rumap(mode, "<C-" .. right .. ">", prefix .. "<cmd>BufferLineCycleNext<CR>", {})
      end
    end

    Api.rumap("n", "<leader>bl", function()
      vim.cmd("BufferLineCloseRight")
      vim.schedule(function() lua_ls.feed(true) end)
    end, {})

    Api.rumap("n", "<leader>bh", function()
      vim.cmd("BufferLineCloseLeft")
      vim.schedule(function() lua_ls.feed(true) end)
    end, {})

    Api.rumap("n", "<leader>bo", function()
      vim.cmd("BufferLineCloseOthers")
      vim.schedule(function() lua_ls.feed(true) end)
    end, {})

    Api.rumap("n", "<leader>bc", function()
      local current_buf = vim.api.nvim_get_current_buf()
      vim.bo.buflisted = false

      local listed_buffers = vim.tbl_filter(function(n)
        return vim.api.nvim_buf_is_loaded(n) and vim.bo[n].buflisted
      end, vim.api.nvim_list_bufs())

      if #listed_buffers == 0 then
        vim.cmd("enew")
        return
      end

      local jumps, current_pos = unpack(vim.fn.getjumplist())

      for i = current_pos, 1, -1 do
        local buf = jumps[i].bufnr

        if vim.api.nvim_buf_is_valid(buf)
          and buf ~= current_buf
          and vim.bo[buf].buflisted
        then
          vim.api.nvim_set_current_buf(buf)
          break
        end
      end
    end, {})
  end,
}
