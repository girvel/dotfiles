local safety = {}

safety.init = function()
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    pattern = ":",
    callback = function() vim.v.errmsg = "" end,
  })

  vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = ":",
    callback = Async.make(function()
      Async.step()
      if not vim.v.errmsg:match("E492") then return end
      local prev_bg = vim.api.nvim_get_hl(0, {}).Normal.bg  ---@diagnostic disable-line:undefined-field
      vim.api.nvim_set_hl(0, "Normal", {bg = "#b30000"})
      Async.sleep(150)
      vim.api.nvim_set_hl(0, "Normal", {bg = prev_bg})
    end)
  })
end

return safety
