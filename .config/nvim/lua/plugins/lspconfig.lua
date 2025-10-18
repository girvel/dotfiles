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
      local menu = require("nui.menu")

      local buf = vim.api.nvim_get_current_buf()

      local word do
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        word = line:sub(1, col):match("([%w%d_]+)$")

        if not word then
          vim.notify("No identifier")
          return
        end
      end

      local candidates do
        candidates = vim.iter(vim.fn.globpath(".", "**/*.lua", true, true))
          :filter(function(path)
            return vim.endswith(path, word .. ".lua")
              or vim.endswith(path, word .. "/init.lua")
          end)
          :map(Api.luapath)
          :map(menu.item)
          :totable()
      end

      Api.feed('<Esc>')
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
              top = " require ",
              top_align = "center",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
          },
        },
        {
          lines = candidates,
          on_submit = function(item)
            -- NEXT no menu if # == 0, but notify
            vim.api.nvim_buf_set_lines(
              buf, 0, 0, false,
              {('local %s = require("%s")'):format(Api.luapath_head(item.text), item.text)}
            )
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
