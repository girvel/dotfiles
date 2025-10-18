local lua_ls = require("lsp.lua_ls")


return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config.lua_ls = lua_ls.config

    vim.lsp.config.clangd = {}

    vim.lsp.config.zls = {}
    vim.g.zig_fmt_autosave = 0

    vim.lsp.config.glsl_analyzer = {}

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.lsp.config.cssls = {
      capabilities = capabilities,
    }

    vim.lsp.config.jedi_language_server = {}

    vim.lsp.config.gopls = {}
  end,
}
