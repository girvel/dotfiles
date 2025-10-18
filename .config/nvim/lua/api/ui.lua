local ui = {}

--- @class ui_progress_bar
--- @field _record any
--- @field _max integer
--- @field _title string
local progress_bar_methods = {}
ui.progress_bar_mt = {__index = progress_bar_methods}

local bar_format = function(value, max)
  return ("%s/%s"):format(value, max)
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

return ui
