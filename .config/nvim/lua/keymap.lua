local builtin = require("telescope.builtin")
local luasnip = require("luasnip")


return {
  run = function()
    -- my own --
    vim.keymap.set("i", "<M-o>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
    end, {remap = true})

    vim.keymap.set("n", "<M-o>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ggO", true, false, true), "n", false)
    end, {remap = true})

    -- vim.keymap.set("n", "<CR>", "za")

    -- nvim-tree --
    vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>")
    vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>")

    -- telescope --
    vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>fr", builtin.resume, {})
    vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
    vim.keymap.set("n", "<leader>ft", builtin.treesitter, {})
    vim.keymap.set("n", "<leader>fd", builtin.oldfiles, {})
    vim.keymap.set("n", "<leader>fn", ":Telescope notify<CR>", {})
    vim.keymap.set('n', '<leader>fu', builtin.lsp_references, {})

    -- lsp --
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})

    -- luasnip --
    vim.keymap.set("i", "<M-CR>", function() luasnip.jump(1) end, {silent = true})

    -- toggleterm --
    vim.keymap.set("n", "<leader>cf", ":ToggleTerm direction=float<CR>")
    vim.keymap.set("n", "<leader>cv", ":ToggleTerm direction=vertical size=80<CR>")
    vim.keymap.set("n", "<leader>ch", ":ToggleTerm direction=horizontal size=15<CR>")

    _G.set_terminal_keymaps = function()
      vim.keymap.set("t", "<esc>", "<C-\\><C-n>")
      vim.keymap.set('t', '<C-w>', "<C-\\><C-n><C-w>")
    end
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

    -- shift safety --
    vim.keymap.set("n", ":W", ":w")
  end,
}
