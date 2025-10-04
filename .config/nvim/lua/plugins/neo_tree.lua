return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  opts = {
    popup_border_style = "rounded",
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = "",
          modified = "",
          deleted = "",
          renamed = "",
          untracked = "u",
          ignored = "",
          unstaged = "U",
          staged = "s",
          conflict = ":",
        },
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)
    Map("n", "<leader>tf", ":Neotree<CR>")
  end
}
