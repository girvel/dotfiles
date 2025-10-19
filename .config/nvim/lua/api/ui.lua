local ui = {}

--- @class ui_progress_bar
--- @field _record any
--- @field _max integer
--- @field _title string
local progress_bar_methods = {}
ui.progress_bar_mt = {__index = progress_bar_methods}

local W = 35 - 2  -- TODO join with notify.min/max_width

local bar_format = function(value, max)
  local n = math.floor(value / max * (W - 2))
  local bar = "[" .. ("#"):rep(n) .. ("_"):rep(W - 2 - n) .. "]"
  local value_length = #tostring(max)
  local indicator = (" %s%s/%s "):format((" "):rep(value_length - #tostring(value)), value, max)
  local indicator_start = math.floor((W - #indicator) / 2)
  return bar:sub(1, indicator_start - 1) .. indicator .. bar:sub(indicator_start + #indicator)
end

--- @return ui_progress_bar
ui.progress_bar = function(title, max)
  return setmetatable({
    _record = vim.notify(
      bar_format(0, max), "info",
      {title = title, timeout = false}
    ),
    _max = max,
    _title = title,
  }, ui.progress_bar_mt)
end

--- @param value integer
progress_bar_methods.update = function(self, value)
  self._record = vim.notify(
    bar_format(value, self._max), nil,
    {replace = self._record, title = self._title, timeout = false}
  )
end

progress_bar_methods.finish = function(self)
  self._record = vim.notify(
    nil, nil,
    {replace = self._record, title = self._title, timeout = 5000}
  )
end

--- @class ui_menu_opts
--- @field width? integer
--- @field height? integer

--- @async
--- @param title string
--- @param items string[]
--- @param opts? ui_menu_opts
ui.menu = function(title, items, opts)
  local menu = require("nui.menu")
  local event = require("nui.utils.autocmd").event

  opts = opts or {}

  local this_menu = menu(
    {
      position = "50%",
      size = {
        width = opts.width or 25,
        height = opts.height or 7,
      },
      border = {
        style = "single",
        text = {
          top = " " .. title .. " ",
          top_align = "center",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
      },
    },
    {
      lines = vim.tbl_map(menu.item, items),
      on_submit = Async.resume(function(item)
        return item.text
      end),
    }
  )
  this_menu:mount()
  this_menu:on(event.BufLeave, function()
    this_menu:unmount()
  end)

  return coroutine.yield()
end

--- @class ui_input_opts
--- @field width? integer

--- @async
--- @param title string
--- @param opts? ui_input_opts
ui.input = function(title, opts)
  local input = require("nui.input")
  local event = require("nui.utils.autocmd").event

  opts = opts or {}

  local this_input = input({
    position = "50%",
    size = {width = opts.width or 30},
    border = {
      style = "single",
      text = {
        top = " " .. title .. " ",
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
  return coroutine.yield()
end

return ui
