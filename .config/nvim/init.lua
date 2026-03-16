Api = require("api.api")
Ui = require("api.ui")
Async = require("api.async")
Config = {
  is_typewriter = os.getenv("TYPEWRITER") ~= nil,
}

require("opt").init()
require("keymap").init()
require("package_manager").init()

if Config.is_typewriter then return end

require("lsp.lua_ls").wrap_diagnostics()
require("snippets").init()
require("neovide").init()
