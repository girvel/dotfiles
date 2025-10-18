local language_styles = require("language_styles")


local opt = {}

opt.init = function()
  vim.opt.relativenumber = true
  vim.opt.number = true

  vim.opt.tabstop = 4
  vim.opt.shiftwidth = 4
  vim.opt.softtabstop = 4

  vim.opt.expandtab = true

  -- neotree for some reason folds all files until unusable
  vim.opt.foldmethod = "manual"

  -- neotree is unstable shit
  vim.opt.splitright = true

  vim.opt.autoindent = true
  vim.opt.smartindent = false
  vim.opt.cindent = false

  vim.opt.termguicolors = true

  vim.g.mapleader = " "

  vim.cmd("filetype indent off")
  vim.cmd("set cc=100")

  vim.opt.title = true
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
      local _, _, title = vim.fn.getcwd():find("/([^/]*)$")
      vim.opt.titlestring = (title or "/"):upper()
    end,
  })

  for lang, data in pairs(language_styles) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = lang,
      callback = function()
        vim.opt_local.tabstop = data.tab
        vim.opt_local.shiftwidth = data.tab
        vim.opt_local.softtabstop = data.tab
      end
    })
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    callback = function()
      vim.opt_local.tabstop = 2
      vim.opt_local.shiftwidth = 2
      vim.opt_local.softtabstop = 2
    end
  })

  vim.diagnostic.config {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
  }

  -- Dealing with "K" documentation popup
  do
    local preview_win

    local close_popup = function()
      if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
        preview_win = nil
      end
    end

    -- Fancy rounded borders w/ correct colors for documentation popup
    local orig = vim.lsp.util.open_floating_preview
    --- @diagnostic disable-next-line
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"

      vim.cmd('set winhighlight=Normal:LspPreview,FloatBorder:LspPreviewBorder')
      local buf, win = orig(contents, syntax, opts, ...)
      vim.cmd('set winhighlight=LspPreview:Normal,LspPreviewBorder:FloatBorder')

      if win then
        preview_win = win
      end

      return buf, win
    end

    -- Fixing popup staying open when navigating (history, telescope, tabs)
    vim.api.nvim_create_autocmd("BufLeave", {
      pattern = "*",
      callback = close_popup,
    })
  end
end

return opt
