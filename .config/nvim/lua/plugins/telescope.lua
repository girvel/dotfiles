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

    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("v", "<leader>fg", '"zy:Telescope live_grep default_text=<C-r>z<cr>', {})
    vim.keymap.set("n", "<leader>fr", builtin.resume, {})
    vim.keymap.set("n", "<leader>fn", ":Telescope notify<CR>", {})
    vim.keymap.set('n', '<leader>fu', builtin.lsp_references, {})
    vim.keymap.set("n", "<leader>fd", '"zyiw:Telescope live_grep default_text=<C-r>z<cr> =', {})
    vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    -- vim.keymap.set("n", "<leader>ft", builtin.treesitter, {})
    -- vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
  end,
}
