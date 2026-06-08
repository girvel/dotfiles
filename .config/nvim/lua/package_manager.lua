local package_manager = {}

package_manager.init = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  local plugins do
    local plugin_configs = vim.fn.readdir(
      vim.fn.stdpath("config") .. "/lua/plugins"
    )

    plugins = {}
    for _, filename in ipairs(plugin_configs) do
      if not vim.endswith(filename, ".lua") then goto continue end
      local mod = require("plugins." .. filename:sub(1, -5))
      if type(mod) == "boolean" then
        if not mod then
          error("Unable to load package "..filename)
        end
        goto continue
      end

      for _, plugin in ipairs(
        type(mod[1]) == "table"
          and mod
          or {mod}
      ) do
        local tags = mod.custom_tags or plugin.custom_tags
        if not Config.is_typewriter or (
          tags and vim.tbl_contains(tags, "lite")
        ) then
          table.insert(plugins, plugin)
        end
      end

      ::continue::
    end
  end

  require("lazy").setup {
    spec = plugins,
    change_detection = {enabled = false},
  }
end

return package_manager
