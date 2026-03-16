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
      local config = require("plugins." .. filename:sub(1, -5))

      if not Config.is_typewriter or (
        config.custom_tags and
        vim.tbl_contains(config.custom_tags, "lite")
      ) then
        table.insert(plugins, config)
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
