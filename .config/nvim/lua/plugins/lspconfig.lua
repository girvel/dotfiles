local luals_fix = require "luals_fix"
return {
  "neovim/nvim-lspconfig",
  config = function()
    local is_attached = false
    vim.lsp.config.lua_ls = {
      on_attach = function()
        if is_attached then return end
        is_attached = true
        vim.schedule(luals_fix.feed)
      end,
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

    -- TODO use this mappings on LSP attach?
    Map("n", "<leader>oo", luals_fix.feed, {})

    Map("i", "<M-.>", function()
      Feed("<Esc>")
      local menu = require("nui.menu")
      menu(
        {
          position = "50%",
          size = {
            width = 25,
            height = 7,
          },
          border = {
            style = "single",
            text = {
              top = "[Test]",
              top_align = "center",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
          },
        },
        {
          lines = {
            menu.item("Hello"),
            menu.item("world"),
          },
          on_submit = function(item)
            vim.notify("Item submitted: " .. item.text)
          end,
        }
      ):mount()
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
