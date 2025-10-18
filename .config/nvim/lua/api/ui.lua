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

return ui
