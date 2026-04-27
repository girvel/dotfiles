return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = { "nvim-lua/plenary.nvim" },
  custom_tags = {"lite"},
  config = function()
    local builtin = require("telescope.builtin")
    local action_state = require("telescope.actions.state")
    local actions = require("telescope.actions")

    require("telescope").setup {
      defaults = {
        file_ignore_patterns = {"%.git/"},
        hidden = true,
        mappings = {
          i = {
            ["<C-f>"] = function(prompt_bufnr)
              actions.send_to_qflist(prompt_bufnr)
              actions.open_qflist()
              local to_replace = action_state.get_current_line():gsub("/", "\\/")
              Api.feed((":cfdo %%s/%s/%s/gc<left><left><left>"):format(to_replace, to_replace))
            end
          },
        },
      },
      pickers = {
        find_files = {hidden = true},
        live_grep = {additional_args = {"--hidden", "--glob", "!*.ldtk"}},
      }
    }

    local keep = function(picker_f)
      return function()
        local default_text = ""

        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "TelescopePrompt" then
            default_text = table.concat(vim.api.nvim_buf_get_lines(
              buf, 0, -1, false
            ), "")
            assert(vim.startswith(default_text, "> "))
            default_text = default_text:sub(3)
            break
          end
        end

        picker_f({default_text = default_text})
      end
    end

    Api.rumap("n", "<leader>ff", keep(builtin.find_files), {})
    Api.rumap("n", "<leader>fo", keep(builtin.oldfiles), {})
    Api.rumap("n", "<leader>fg", keep(builtin.live_grep), {})
    Api.rumap("n", "<leader>fh", keep(builtin.help_tags), {})
    Api.rumap("n", "<leader>fm", keep(builtin.keymaps), {})

    Api.rumap("v", "<leader>fg", '"zy:Telescope live_grep default_text=<C-r>z<cr>', {})
    Api.rumap("n", "<leader>fr", builtin.resume, {})
    Api.rumap("n", "<leader>fn", ":Telescope notify<CR>", {})
    Api.rumap('n', '<leader>fu', builtin.lsp_references, {})
    Api.rumap("n", "<leader>fd", '"zyiw:Telescope live_grep default_text=<C-r>z<cr> =', {})
    Api.rumap("n", "gd", builtin.lsp_definitions, {})
    -- Api.rumap("n", "<leader>ft", builtin.treesitter, {})
    -- Api.rumap("n", "<leader>fb", builtin.buffers, {})
    Api.rumap("v", "<leader>rr", '"zy:%s/<C-r>z/<C-r>z')
  end,
}
