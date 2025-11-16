Api = require("api.api")
Ui = require("api.ui")
Async = require("api.async")

require("lsp.lua_ls").wrap_diagnostics()

require("opt").init()
require("package_manager").init()
require("snippets").init()
require("keymap").init()
require("neovide").init()
