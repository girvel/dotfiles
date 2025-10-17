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

    Map("n", "<leader>ff", builtin.find_files, {})
    Map("n", "<leader>fo", builtin.oldfiles, {})
    Map("n", "<leader>fg", builtin.live_grep, {})
    Map("v", "<leader>fg", '"zy:Telescope live_grep default_text=<C-r>z<cr>', {})
    Map("n", "<leader>fr", builtin.resume, {})
    Map("n", "<leader>fn", ":Telescope notify<CR>", {})
    Map('n', '<leader>fu', builtin.lsp_references, {})
    Map("n", "<leader>fd", '"zyiw:Telescope live_grep default_text=<C-r>z<cr> =', {})
    Map("n", "gd", builtin.lsp_definitions, {})
    Map("n", "<leader>fh", builtin.help_tags, {})
    -- Map("n", "<leader>ft", builtin.treesitter, {})
    -- Map("n", "<leader>fb", builtin.buffers, {})
    Map("v", "<leader>rr", '"zy:%s/<C-r>z/<C-r>z')
  end,
}
