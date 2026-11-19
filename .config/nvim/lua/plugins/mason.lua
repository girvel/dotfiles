return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        {"mason-org/mason.nvim", opts = {}},
        "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "lua_ls",
        "emmet_language_server",
      },
    },
  }
}
