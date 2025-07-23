return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "clangd",
        "gopls",
        "lua_ls",
        "zls",
        "cssls",
        "ts_ls",
      },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.lua_ls.setup({
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
            },
            misc = {
              parameters = {"--loglevel=trace", "--logpath=/home/girvel/.lua-language-server/log"},
            },
          }
        }
      })

      lspconfig.clangd.setup {}

      lspconfig.zls.setup {}
      vim.g.zig_fmt_autosave = 0

      lspconfig.glsl_analyzer.setup {}

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      lspconfig.cssls.setup {
        capabilities = capabilities,
      }

      lspconfig.jedi_language_server.setup {}

      lspconfig.gopls.setup {}
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        -- Plugin configuration

        tools = {
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)

            -- you can also put keymaps in here
          end,
          default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
            },
          },

        },

        -- DAP configuration
        dap = {
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<M-Up>"] = cmp.mapping.select_prev_item(),
          ["<M-Down>"] = cmp.mapping.select_next_item(),
          ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        },

        sources = {
          { name = "path" },
          { name = "nvim_lsp", keyword_length = 3 },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lua", keyword_length = 2 },
          { name = "buffer", keyword_length = 2 },
          { name = "luasnip" },
          { name = "calc" },
        },

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          fields = {"menu", "abbr", "kind"},
          format = function(_, item)
            return item
          end,
        },
      })
    end,
  },
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-nvim-lua"},
  {"hrsh7th/cmp-nvim-lsp-signature-help"},
  {"hrsh7th/cmp-path"},
  {"hrsh7th/cmp-buffer"},
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "rust", "toml", "glsl" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        ident = { enable = false },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
        },
      })

      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo.foldlevel = 99
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup {
        defaults = {
          file_ignore_patterns = {".git"},
          hidden = true,
        },
        pickers = {
          find_files = {hidden = true},
          live_grep = {additional_args = {"--hidden"}},
        }
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    config = function()
      require("luasnip.loaders.from_lua").load({paths = "./snippets"})
    end,
  },
  {"saadparwaiz1/cmp_luasnip"},
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {},
  },
}
