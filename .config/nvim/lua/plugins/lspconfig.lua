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
    vim.lsp.config.clangd = {
      on_attach = function(client, bufnr)
        -- disable graying based on #ifdef
        client.server_capabilities.semanticTokensProvider = nil

        Api.rumap("n", "<leader>lu", function()
          local text = vim.api.nvim_get_current_line()
          local rettype, name, signature = text:match("^(.+ %*?)(%S+)(%([^%)]*%))")
          if not name or not signature then
            vim.notify("Unable to recognize a function name/signature pair", vim.log.levels.ERROR)
            return
          end

          local filepath = vim.api.nvim_buf_get_name(0)
          local matching_file
          local started_in_header = vim.endswith(filepath, ".h")
          if started_in_header then
            matching_file = filepath:sub(1, -3)..".c"
          elseif vim.endswitch(filepath, ".c") then
            matching_file = filepath:sub(1, -3)..".h"
          else
            error("Unsupported extension")
          end

          local matching_bufnr = vim.fn.bufadd(matching_file)
          vim.fn.bufload(matching_bufnr)

          local lines = vim.api.nvim_buf_get_lines(matching_bufnr, 0, -1, false)
          for i, line in ipairs(lines) do
            if line:find(rettype..name, 1, true) then
              local new_line = rettype..name..signature
              if not started_in_header then new_line = new_line..";" end

              if new_line == line then
                print("Same")
              else
                vim.api.nvim_buf_set_lines(matching_bufnr, i - 1, i, false, {new_line})
                vim.bo[matching_bufnr].buflisted = true
                print("Updated")
              end

              return
            end
          end

          print("Have not found matching "..(started_in_header and "definition" or "declaration"))
        end, {desc = "LSP: sync (update) declaration/definition signature"})
      end,
    }
    vim.lsp.config.glsl_analyzer = {}
    vim.lsp.config.jedi_language_server = {}
    vim.lsp.config.gopls = {
      on_attach = function(client, bufnr)
        client.server_capabilities.semanticTokensProvider = nil
      end,
    }

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    vim.lsp.config.cssls = {
      capabilities = capabilities,
    }

    vim.lsp.config.zls = {}
    vim.g.zig_fmt_autosave = 0
  end,
}
