return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  branch = "main",
  config = function()
    -- NixOS gets weird without that
    local parser_path = vim.fn.stdpath("data") .. "/treesitter-parsers"
    vim.opt.runtimepath:prepend(parser_path)

    local treesitter = require("nvim-treesitter")
    treesitter.setup()
    treesitter.install {
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
    }
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args) pcall(vim.treesitter.start, args.buf) end,
    })

    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo.foldlevel = 99
  end,
}
