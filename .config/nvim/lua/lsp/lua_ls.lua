local lua_ls = {}

local SECOND = 1000000000

--- @async
lua_ls.feed = function(silent)
  local buffers = vim.iter(vim.fn.globpath(".", "**/*.lua", true, true))
    :map(function(path) return vim.fn.bufadd(vim.fn.fnamemodify(path, ":p")) end)
    :filter(function(buf) return vim.fn.bufloaded(buf) == 0 end)
    :totable()

  if #buffers == 0 then return end

  local bar = Ui.progress_bar("LuaLS fix", #buffers)
  Async.step()

  local start_t = vim.uv.hrtime()

  for i, buf in ipairs(buffers) do
    bar:update(i)
    vim.fn.bufload(buf)
    vim.bo[buf].buflisted = false

    if vim.uv.hrtime() - start_t >= .1 * SECOND then
      Async.step()
      start_t = vim.uv.hrtime()
    end
  end

  bar:finish()
end

--- @async
lua_ls.auto_require = function(word)
  local menu = require("nui.menu")
  local input = require("nui.input")
  local event = require("nui.utils.autocmd").event

  local buf = vim.api.nvim_get_current_buf()

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

  Api.feed('<Esc>')
  Async.step()

  local modpath
  if #candidates == 0 then
    -- TODO in the future -- Ui.input
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
      on_submit = Async.resume(),
    })

    this_input:mount()
    this_input:on(event.BufLeave, function()
      this_input:unmount()
    end)
    modpath = coroutine.yield()
  else
    if #candidates == 1 then
      modpath = candidates[1].text
      vim.notify(("Required %q"):format(modpath))
    else
    -- TODO in the future -- Ui.menu
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
          on_submit = Async.resume(function(item)
            return item.text
          end),
        }
      )
      this_menu:mount()
      this_menu:on(event.BufLeave, function()
        this_menu:unmount()
      end)
      modpath = coroutine.yield()
    end
  end

  insert_require(modpath)
  Api.feed("i")
  Async.step()
end

local is_attached = false

lua_ls.config = {
  on_attach = Async.make(function()
    if is_attached then return end
    is_attached = true

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
      vim.api.nvim_put({"."}, "c", true, true)

      Async.sleep(20)
      cmp.complete()
    end, {})

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

    Async.step()
    lua_ls.feed()
  end),
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
