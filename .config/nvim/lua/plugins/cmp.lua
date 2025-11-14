return {
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local lspkind = require("lspkind")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-S-j>"] = cmp.mapping.scroll_docs(4),
          ["<C-S-k>"] = cmp.mapping.scroll_docs(-4),
          ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          ["<M-CR>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end),
        },

        sources = {
          { name = "nvim_lsp", keyword_length = 1 },
          { name = "nvim_lua", keyword_length = 1 },
          { name = "buffer", keyword_length = 1 },
          { name = "luasnip" },
          { name = "calc" },
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        performance = {
          max_view_entries = 20,
        },

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format {
            mode = "symbol",
            maxwidth = {
              menu = 50,
              abbr = 50,
            },
            ellipsis_char = '...',
            show_labelDetails = true,
          },
        },
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end,
  },
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-nvim-lua"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-cmdline"},
  {"saadparwaiz1/cmp_luasnip"},
  {"onsails/lspkind.nvim"},
}
