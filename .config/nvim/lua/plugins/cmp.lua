local lua_ls = require("lsp.lua_ls")


return {
  {
    "hrsh7th/nvim-cmp",
    custom_tags = {"lite"},
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")

      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰊄",
      }

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
          {
            name = "nvim_lsp",
            keyword_length = 1,
            entry_filter = lua_ls.cmp_filter,
          },
          {name = "nvim_lua", keyword_length = 1},
          {name = "buffer", keyword_length = 1},
          {name = "luasnip"},
          {name = "calc"},
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
          format = function(entry, vim_item)
            vim_item.kind = kind_icons[vim_item.kind] or vim_item.kind
            if string.len(vim_item.abbr or "") > 50 then
              vim_item.abbr = vim_item.abbr:sub(1, 47).."..."
            end
            if string.len(vim_item.menu or "") > 50 then
              vim_item.menu = vim_item.menu:sub(1, 47).."..."
            end
            return vim_item
          end,
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
  {
    "hrsh7th/cmp-buffer",
    custom_tags = {"lite"},
  },
  {
    "hrsh7th/cmp-cmdline",
    custom_tags = {"lite"},
  },
  {
    "saadparwaiz1/cmp_luasnip",
    custom_tags = {"lite"},
  },
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-nvim-lua"},
}
