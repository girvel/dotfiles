local clangd = {}

local update_signature = function()
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
  elseif vim.endswith(filepath, ".c") then
    matching_file = filepath:sub(1, -3)..".h"
  else
    error("Unsupported extension")
  end

  local matching_bufnr = vim.fn.bufadd(matching_file)
  vim.fn.bufload(matching_bufnr)

  local lines = vim.api.nvim_buf_get_lines(matching_bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:match("^%S+ %*?"..name.."%(") then
      local postfix
      local brackets_opened = false
      local brackets_n = 0
      for j = 1, #line do
        if brackets_opened and brackets_n == 0 then
          postfix = line:sub(j)
          goto postfix_ok
        end
        local ch = line:sub(j, j)
        if ch == "(" then
          brackets_opened = true
          brackets_n = brackets_n + 1
        elseif ch == ")" then
          brackets_n = brackets_n - 1
          if brackets_n < 0 then break end
        end
      end
      vim.notify(("Wrong format of the line '%s'"):format(line), vim.log.levels.ERROR)
      ::postfix_ok::

      local new_line = rettype..name..signature..postfix

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
end

local toggle_header = function()
  local filepath = vim.api.nvim_buf_get_name(0)
  local matching_file
  if vim.endswith(filepath, ".h") then
    matching_file = filepath:sub(1, -3)..".c"
  elseif vim.endswith(filepath, ".c") then
    matching_file = filepath:sub(1, -3)..".h"
  else
    error("Unsupported extension")
  end

  local matching_bufnr = vim.fn.bufadd(matching_file)
  vim.fn.bufload(matching_bufnr)
  vim.api.nvim_set_current_buf(matching_bufnr)
end

clangd.get_config = function()
  return {
    on_attach = function(client, bufnr)
      -- disable graying based on #ifdef
      client.server_capabilities.semanticTokensProvider = nil

      Api.rumap(
        "n", "<leader>lu", update_signature,
        {desc = "LSP: sync (update) declaration/definition signature"}
      )

      Api.rumap(
        "n", "<leader>lt", toggle_header,
        {desc = "LSP: toggle between header & source"}
      )
    end,
  }
end

return clangd
