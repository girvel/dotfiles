local xdg_extensions = {
  png = true, jpg = true, jpeg = true, gif = true,
  webp = true, bmp = true, ico = true, svg = true,
}

return {
  "nvim-tree/nvim-tree.lua",
  custom_tags = {"lite"},
  config = function()
    require("nvim-tree").setup({
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        local open = function()
          local node = api.tree.get_node_under_cursor()
          if node and node.type == "file" then
            local extension = node.name:match("%.([^%.]+)$")
            extension = extension and extension:lower()
            if xdg_extensions[extension] then
              vim.fn.jobstart({"xdg-open", node.absolute_path}, {detach = true})
              return
            end
          end

          api.node.open.edit()
        end

        local open_inplace = function()
          api.node.open.edit()
          api.tree.close()
        end

        api.config.mappings.default_on_attach(bufnr)
        Api.rumap("n", "o", open_inplace, {buffer = bufnr})
        Api.rumap("n", "<CR>", open, {buffer = bufnr})
      end,
    })
    Api.rumap("n", "<leader>tf", ":NvimTreeFocus<CR>")
    Api.rumap("n", "<leader>tr", ":NvimTreeRefresh<CR>")
    Api.rumap("n", "<leader>tc", ":NvimTreeClose<CR>")
  end
}
