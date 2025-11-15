local lua_ls = require("lsp.lua_ls")


local SIGNS = {
  error = " ",
  warn = " ",
  hint = " ",
  info = " ",
}

return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = SIGNS.error,
          [vim.diagnostic.severity.WARN]  = SIGNS.warn,
          [vim.diagnostic.severity.HINT]  = SIGNS.hint,
          [vim.diagnostic.severity.INFO]  = SIGNS.info,
        },
      },
      virtual_text = {
        prefix = function(diagnostic)
          for d, sign in pairs(SIGNS) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return sign
            end
          end
          return "●"
        end,
      },
    }

    vim.lsp.config.lua_ls = lua_ls.get_config()
    vim.lsp.config.clangd = {}
    vim.lsp.config.glsl_analyzer = {}
    vim.lsp.config.jedi_language_server = {}
    vim.lsp.config.gopls = {}

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    vim.lsp.config.cssls = {
      capabilities = capabilities,
    }

    vim.lsp.config.zls = {}
    vim.g.zig_fmt_autosave = 0
  end,
}
