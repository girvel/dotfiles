local lua_ls = {}


local init_mappings
local is_attached = false

lua_ls.get_config = function()
  return {
    on_attach = Async.make(function()
      if is_attached then return end
      is_attached = true

      init_mappings()

      Async.step()
      lua_ls.feed()
    end),

    settings = {
      Lua = {
        completion = {
          autoRequire = false,
        },
        runtime = {
          version = "LuaJIT"
        },
        diagnostics = {
          globals = {"vim", "love"},
          unusedLocalExclude = {"_*", "self"},
        },
        workspace = {
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/love2d/library",
            "${3rd}/luasocket/library",
          },
          maxPreload = 1000000000000,
          preloadFileSize = 10000,
        },
      }
    }
  }
end


-------------------------------------------------------------------------------------
-- [SECTION] Unfucking LuaLS
-------------------------------------------------------------------------------------

local is_wrapped = false

--- Fixes the annoying unused-local hints for function parameters
lua_ls.wrap_diagnostics = function()
  if is_wrapped then return end
  is_wrapped = true

  --- @param diagnostic vim.Diagnostic
  local exclude_bullshit = function(diagnostic, bufnr)
    if diagnostic.code ~= "unused-local" or diagnostic.source ~= "Lua Diagnostics." then return true end

    local line = vim.api.nvim_buf_get_lines(bufnr, diagnostic.lnum, diagnostic.lnum + 1, false)[1]
    if not line then return true end

    return not line:find("function")
  end

  local original = vim.diagnostic.set
  --- @diagnostic disable-next-line: duplicate-set-field
  vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
    local filtered = vim.iter(diagnostics)
      :filter(function(d) return exclude_bullshit(d, bufnr) end)
      :totable()

    return original(namespace, bufnr, filtered, opts)
  end
end

local SECOND = 1000000000

--- Fixes LuaLS failing to load all of the project
--- @async
lua_ls.feed = function(silent)
  local buffers = vim.iter(vim.fn.globpath(".", "**/*.lua", true, true))
    :map(function(path) return vim.fn.bufadd(vim.fn.fnamemodify(path, ":p")) end)
    :filter(function(buf) return vim.fn.bufloaded(buf) == 0 end)
    :totable()

  if #buffers == 0 then return end

  local bar = not silent and Ui.progress_bar("LuaLS fix", #buffers)  --[[@as ui_progress_bar?]]
  Async.step()

  local start_t = vim.uv.hrtime()

  for i, buf in ipairs(buffers) do
    if bar then bar:update(i) end
    vim.fn.bufload(buf)
    vim.bo[buf].buflisted = false

    if vim.uv.hrtime() - start_t >= .1 * SECOND then
      Async.step()
      start_t = vim.uv.hrtime()
    end
  end

  if bar then bar:finish() end
end

--- Replaces LuaLS' quantum shit autorequire
--- @async
lua_ls.auto_require = function(word)
  local buf = vim.api.nvim_get_current_buf()

  local chunk_size = 50
  local row = 0

  while true do
    local lines = vim.api.nvim_buf_get_lines(buf, row, row + chunk_size, false)
    if #lines == 0 then break end

    for _, line in ipairs(lines) do
      if line:match("^local%s+"..word.."%s*=%s*require") then
        return
      elseif not line:match("^%s*$")
        or line:match("^%s*%-%-")
        or line:match("^local%s+[%w_]+%s*=%s*require")
      then
        goto scan_done
      end
    end
  end

  ::scan_done::

  local candidates do
    candidates = vim.iter(vim.fn.globpath(".", "**/*.lua", true, true))
      :filter(function(path)
        return vim.endswith(path, "/" .. word .. ".lua")
          or vim.endswith(path, "/" .. word .. "/init.lua")
      end)
      :map(Api.luapath)
      :totable()
  end

  Api.feed('<Esc>')
  Async.step()

  -- TODO bug normal mode in input
  local modpath
  if #candidates == 0 then
    local raw_path = Ui.telescope_file_picker("enter modpath for '"..word.."'")
    if not raw_path then return end
    modpath = Api.luapath(raw_path)
  else
    if #candidates == 1 then
      modpath = candidates[1]
      vim.notify(("Required %q"):format(modpath))
    else
      modpath = Ui.menu("choose modpath", candidates)
    end
  end

  vim.api.nvim_buf_set_lines(
    buf, 0, 0, false,
    {('local %s = require("%s")'):format(word, modpath)}
  )
  Api.feed("a")
  Async.step()
end

--- Entry filter for cmp's nvim_lsp source, fixing the function snippet with the wrong spacing
lua_ls.cmp_filter = function(entry, ctx)
  if ctx.filetype == "lua" then
    local text = entry.completion_item.insertText
    return not text or not text:find("function ", 1, true)
  end
  return true
end


----------------------------------------------------------------------------------------------------
-- [SECTION] Nice things
----------------------------------------------------------------------------------------------------

local read_identity = function()
  local folder_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  if vim.uv.fs_stat("./conf.lua") == nil then
    return folder_name
  end

  love = {}
  local ok, res = pcall(dofile, "./conf.lua")
  if not ok then
    vim.notify(
      ("dofile error for ./conf.lua, is this a LOVE project?\n%s"):format(res),
      vim.log.levels.ERROR
    )
    love = nil  --- @diagnostic disable-line
    return
  end

  local config = {window = {}}
  ok, res = pcall(love.conf, config)
  love = nil  --- @diagnostic disable-line
  if not ok then
    vim.notify(
      ("Error running love.conf, ./conf.lua may be broken.\n%s"):format(res),
      vim.log.levels.ERROR
    )
    return
  end

  return config.identity or folder_name
end

lua_ls.parse_last_log = function()
  local identity = read_identity()
  if not identity then return end

  local filepath do
    local logs = vim.fn.globpath("~/.local/share/love/" .. identity .. "/logs", "*.txt", true, true)
    table.sort(logs)
    filepath = logs[#logs]
  end

  local lines = vim.fn.readfile(filepath)  --[=[@as string[]]=]
  local stacks = {}
  for i = #lines, 1, -1 do
    local line = lines[i]
    local level, frame, message = line:match("^%[([A-Z]+)%s+%S+%s+(%d+)%]%s+(.*)")
    if level ~= "FATAL" and level ~= "ERROR" and level ~= "WARN" then
      goto continue
    end

    local stack = {items = {}, message = ("%s %s %s"):format(level, frame, message)}
    stack.items = {}
    for j = i + 1, #lines do
      local stack_line = lines[j]
      if j > i and stack_line:sub(1, 1) == "[" then break end
      if stack_line:find("stack traceback", 1, true) then
        table.insert(stack.items, {text = stack_line})
      else
        local path, row = stack_line:match("^%s+(%S+%.lua):(%d+)")
        if path then
          local function_name = stack_line:match("in function '([^']*)'")
          table.insert(stack.items, {
            text = function_name and (function_name .. "()") or "",
            lnum = row,
            bufnr = vim.fn.bufadd(path)
          })
        end
      end
    end
    table.insert(stacks, stack)

    ::continue::
  end

  local stack
  if #stacks == 1 then
    stack = stacks[1].items
  else
    local stack_name = #stacks == 1
      and stacks[1]
      or Ui.menu(
        "errors",
        vim.tbl_map(function(s) return s.message end, stacks),
        {width = 80}
      )

    stack = vim.iter(stacks)
      :find(function(s) return s.message == stack_name end)
      .items
  end

  vim.fn.setqflist(stack)
  vim.cmd("copen | wincmd L | vertical resize 40 | file STACK")
  Async.step()

  Api.feed("<C-w>h")
end

init_mappings = function()
  Api.rumap("n", "<leader>oo", lua_ls.feed, {})

  Api.rumap("i", "<M-.>", function()
    local cmp = require("cmp")

    local word do
      local line = vim.api.nvim_get_current_line()
      local col = vim.api.nvim_win_get_cursor(0)[2]
      word = line:sub(1, col):match("([%w%d_]*)$")

      if not word then
        vim.notify("No identifier")
        return
      end
    end

    lua_ls.auto_require(word)
    Api.feed(".")

    Async.sleep(20)
    cmp.complete()
  end, {})

  -- TODO maybe visual mode
  for _, mode in ipairs {"i", "n"} do
    Api.rumap(mode, "<M-,>", function()
      local word do
        local line = vim.api.nvim_get_current_line()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        word = line:sub(1, col):match("([%w%d_]*)$")
          .. line:sub(col + 1):match("^([%w%d_]*)")

        if not word then
          vim.notify("No identifier")
          return
        end
      end

      lua_ls.auto_require(word)
      if mode == "n" then
        Api.feed("<Esc>")
      end
    end, {})
  end

  -- TODO Api.rumap supporting multiple modes
  Api.rumap("n", "<C-e>", lua_ls.parse_last_log, {})
  Api.rumap("n", "<C-S-e>", ":cclose<CR>", {})

  for _, tuple in ipairs {
    {"j", "cnext"},
    {"k", "cprevious"},
  } do
    local key, cmd = unpack(tuple)
    Api.rumap("n", "<M-" .. key .. ">", function()
      local listed_bufs = vim.tbl_filter(
        function(b) return vim.api.nvim_buf_is_loaded(b) and vim.bo[b].buflisted end,
        vim.api.nvim_list_bufs()
      )
      vim.cmd(cmd)

      Async.step()
      local buf = vim.api.nvim_get_current_buf()
      if not vim.tbl_contains(listed_bufs, buf) then
        vim.bo[buf].buflisted = false
      end
    end, {})
  end
end

return lua_ls
