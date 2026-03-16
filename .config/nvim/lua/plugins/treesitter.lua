return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  branch = "master",
  config = function()
    -- NixOS gets weird without that
    local parser_path = vim.fn.stdpath("data") .. "/treesitter-parsers"
    vim.opt.runtimepath:prepend(parser_path)

    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "bash",
        "c",
        "go",
        "glsl",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "rust",
        "toml",
        "toml",
        "typescript",
        "xml",
        "yaml",
      },

      highlight = {
        enable = true,
      },
    })

    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
  end,
}
