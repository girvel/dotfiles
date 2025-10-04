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

    vim.api.nvim_create_autocmd('VimEnter', {
      pattern = '*',
      callback = function()
        vim.schedule(function()
          for _, id in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(id)
            if vim.bo[buf].filetype == "" then
              vim.api.nvim_win_close(id, true)
              vim.api.nvim_buf_delete(buf, {force = true})
              break
            end
          end
        end)
      end,
    })
  end
}
