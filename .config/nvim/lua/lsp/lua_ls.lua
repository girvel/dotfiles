local lua_ls = {}

lua_ls.feed = function(silent)
  local files = vim.fn.globpath(".", "**/*.lua", true, true)
  local counter = 0
  for _, path in ipairs(files) do
    path = vim.fn.fnamemodify(path, ":p")
    local n = vim.fn.bufadd(path)
    if vim.fn.bufloaded(n) == 0 then
      vim.fn.bufload(n)
      vim.bo[n].buflisted = false
      counter = counter + 1
    end
  end

  if not silent and #files > 0 then
    vim.notify(("LuaLS fix: loaded %s files"):format(counter))
  end
end

lua_ls.auto_require = function()
  local menu = require("nui.menu")
  local input = require("nui.input")
  local event = require("nui.utils.autocmd").event

  local buf = vim.api.nvim_get_current_buf()

  local word do
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    word = line:sub(1, col):match("([%w%d_]+)$")

    if not word then
      vim.notify("No identifier")
      return
    end
  end

  local candidates do
    candidates = vim.iter(vim.fn.globpath(".", "**/*.lua", true, true))
      :filter(function(path)
        return vim.endswith(path, word .. ".lua")
          or vim.endswith(path, word .. "/init.lua")
      end)
      :map(Api.luapath)
      :map(menu.item)
      :totable()
  end

  local insert_require = function(modpath)
    vim.api.nvim_buf_set_lines(
      buf, 0, 0, false,
      {('local %s = require("%s")'):format(word, modpath)}
    )
  end

  if #candidates == 0 then
    local this_input = input({
      position = "50%",
      size = {width = 30},
      border = {
        style = "single",
        text = {
          top = " enter modpath ",
          top_align = "center",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
      },
    }, {
      prompt = "> ",
      on_submit = function(value)
        insert_require(value)
        Api.feed("a")
      end,
    })

    this_input:mount()
    this_input:on(event.BufLeave, function()
      this_input:unmount()
    end)
    return
  end

  Api.feed('<Esc>')

  if #candidates == 1 then
    vim.schedule(function()
      local modpath = candidates[1].text
      insert_require(modpath)
      vim.notify(("Required %q"):format(modpath))
      Api.feed("a")
    end)
    return end

  local this_menu = menu(
    {
      position = "50%",
      size = {
        width = 25,
        height = 7,
      },
      border = {
        style = "single",
        text = {
          top = " require ",
          top_align = "center",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
      },
    },
    {
      lines = candidates,
      on_submit = function(item)
        insert_require(item.text)
        Api.feed("a")
      end,
    }
  )
  this_menu:mount()
  this_menu:on(event.BufLeave, function()
    this_menu:unmount()
  end)
end

local is_attached = false

lua_ls.config = {
  on_attach = function()
    if is_attached then return end
    is_attached = true
    vim.schedule(lua_ls.feed)

    Api.rumap("n", "<leader>oo", lua_ls.feed, {})
    Api.rumap("i", "<M-.>", lua_ls.auto_require, {})
  end,
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
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    }
  }
}

return lua_ls
