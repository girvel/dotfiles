return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.lsp.config.lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT"
          },
          diagnostics = {
            globals = {"vim", "love"},
            -- disable = {"unused-local"},
          },
          workspace = {
            library = {
              vim.env.VIMRUNTIME,
              -- "~/Applications/lsp/lua-language-server/meta/3rd/love2d",
              "${3rd}/love2d/library",
              "${3rd}/luasocket/library",
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
          },
        }
      }
    }

    Map("n", "<leader>oo", function()
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
