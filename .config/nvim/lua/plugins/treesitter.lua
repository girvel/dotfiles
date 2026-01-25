return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- NixOS gets weird without that
    local parser_path = vim.fn.stdpath("data") .. "/treesitter-parsers"
    vim.opt.runtimepath:prepend(parser_path)

    require("nvim-treesitter").install({
      "bash",
      "c",
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
    })

    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
  end,
}
