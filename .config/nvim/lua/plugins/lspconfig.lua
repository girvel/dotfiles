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

    -- NEXT use this mappings on LSP attach?
    Map("n", "<leader>oo", luals_fix.feed, {})

    Map("i", "<M-.>", function()
      local menu = require("nui.menu")
      local input = require("nui.input")
      local event = require("nui.utils.autocmd").event

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

      local insert_require = function(modpath)
        vim.api.nvim_buf_set_lines(
          buf, 0, 0, false,
          {('local %s = require("%s")'):format(word, modpath)}
        )
      end

      if #candidates == 0 then
        local this_input = input({
          position = "50%",
          size = {width = 30},
          border = {
            style = "single",
            text = {
              top = " enter modpath ",
              top_align = "center",
            },
          },
          win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
          },
        }, {
          prompt = "> ",
          on_submit = function(value)
            insert_require(value)
            Api.feed("a")
          end,
        })

        this_input:mount()
        this_input:on(event.BufLeave, function()
          this_input:unmount()
        end)
        return
      end

      Api.feed('<Esc>')

      if #candidates == 1 then
        vim.schedule(function()
          local modpath = candidates[1].text
          insert_require(modpath)
          vim.notify(("Required %q"):format(modpath))
          Api.feed("a")
        end)
        return end

      local this_menu = menu(
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
            insert_require(item.text)
            Api.feed("a")
          end,
        }
      )
      this_menu:mount()
      this_menu:on(event.BufLeave, function()
        this_menu:unmount()
      end)
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
