local luasnip = require("luasnip")


return {
  init = function()
    -- my own --
    vim.keymap.set("i", "<M-o>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>ggO", true, false, true), "n", false)
    end, {remap = true})

    vim.keymap.set("n", "<M-o>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("ggO", true, false, true), "n", false)
    end, {remap = true})

    vim.keymap.set("n", "<leader>oo", function()
      local files = vim.fn.globpath(".", "**/*.lua", true, true)
      for _, path in ipairs(files) do
        path = vim.fn.fnamemodify(path, ":p")
        local n = vim.fn.bufadd(path)
        vim.fn.bufload(n)
        vim.bo[n].buflisted = false
      end

      if #files > 0 then
        vim.notify(("LuaLS fix: loaded %s files"):format(#files))
      end
    end, {})

    -- nvim-tree --
    vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>")
    vim.keymap.set("n", "<leader>tr", ":NvimTreeRefresh<CR>")

    -- telescope --
    -- lsp --
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, {})
    vim.keymap.set("n", "<leader>lf", vim.diagnostic.open_float, {})
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})

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
