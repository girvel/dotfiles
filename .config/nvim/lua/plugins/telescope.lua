return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup {
      defaults = {
        file_ignore_patterns = {".git"},
        hidden = true,
      },
      pickers = {
        find_files = {hidden = true},
        live_grep = {additional_args = {"--hidden", "--glob", "!*.ldtk"}},
      }
    }

    local builtin = require("telescope.builtin")

    Api.rumap("n", "<leader>ff", builtin.find_files, {})
    Api.rumap("n", "<leader>fo", builtin.oldfiles, {})
    Api.rumap("n", "<leader>fg", builtin.live_grep, {})
    Api.rumap("v", "<leader>fg", '"zy:Telescope live_grep default_text=<C-r>z<cr>', {})
    Api.rumap("n", "<leader>fr", builtin.resume, {})
    Api.rumap("n", "<leader>fn", ":Telescope notify<CR>", {})
    Api.rumap('n', '<leader>fu', builtin.lsp_references, {})
    Api.rumap("n", "<leader>fd", '"zyiw:Telescope live_grep default_text=<C-r>z<cr> =', {})
    Api.rumap("n", "gd", builtin.lsp_definitions, {})
    Api.rumap("n", "<leader>fh", builtin.help_tags, {})
    -- Api.rumap("n", "<leader>ft", builtin.treesitter, {})
    -- Api.rumap("n", "<leader>fb", builtin.buffers, {})
    Api.rumap("v", "<leader>rr", '"zy:%s/<C-r>z/<C-r>z')
  end,
}
