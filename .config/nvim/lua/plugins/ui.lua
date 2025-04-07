return {
  -- fancy icons
  {"nvim-tree/nvim-web-devicons"},

  -- theme: monokai
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      if vim.fn.has("wsl") == 1 then
        require("monokai-pro").setup {
          filter = "spectrum",
        }
        vim.cmd.colorscheme("monokai-pro")
      end
    end
  },

  -- sidebar with files
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({})
    end
  },

  -- fancy notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      vim.notify.setup {
        render = "wrapped-compact",
        minimum_width = 35,
        max_width = 35,
      }
    end,
  },

  -- fancy bottom line
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
      require("lualine").setup {
        options = {
          theme = "monokai-pro",
        },
      }
    end,
  },

  -- terminal pane
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {}
    end,
  },

  -- fancy tabs
  -- {
  --   "akinsho/bufferline.nvim",
  --   dependencies = "nvim-tree/nvim-web-devicons",
  --   config = function()
  --     require("bufferline").setup {
  --       options = {
  --         separator_style = "slant",
  --       },
  --     }
  --   end,
  -- },

  -- wildmenu tooltips
  {
    "gelguy/wilder.nvim",
    config = function()
      local wilder = require("wilder")
      wilder.setup {
        modes = {":", "/", "?"},
      }
    end,
  },
}
