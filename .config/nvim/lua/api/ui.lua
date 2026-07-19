local core = require("core.init")


local ui = {}

--- @class ui_progress_bar
--- @field _record any
--- @field _max integer
--- @field _title string
local progress_bar_methods = {}
ui.progress_bar_mt = {__index = progress_bar_methods}

local BAR_W = core.layout.notification.w - 2

local bar_format = function(value, max)
  local bar do
    local w = BAR_W - 2
    local n = math.floor(value / max * w)
    bar = "[" .. ("#"):rep(n) .. ("_"):rep(w - n) .. "]"
  end

  local indicator do
    local value_length = #tostring(max)
    indicator = (" %s%s/%s "):format((" "):rep(value_length - #tostring(value)), value, max)
  end

  local overlap_i = math.floor((BAR_W - #indicator) / 2)
  return bar:sub(1, overlap_i - 1) .. indicator .. bar:sub(overlap_i + #indicator)
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

--- @async
--- @param title string
--- @param default string?
--- @return string?
ui.telescope_file_picker = function(title, default)
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")

  local thread = coroutine.running()

  builtin.find_files({
    prompt_title = title,
    default_text = default,
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        coroutine.resume(thread, selection and selection[1] or nil)
      end)

      vim.api.nvim_create_autocmd("BufLeave", {
        buffer = prompt_bufnr,
        once = true,
        callback = function()
          vim.schedule(function() coroutine.resume(thread, nil) end)
        end,
      })

      return true
    end,
  })

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
