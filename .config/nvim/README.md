# Neovim configuration

## Internal knowledge

- For some reason, `lua_ls` is fucked on any linux machine I own; IDK how to unfuck it the conventional way, so there's an `lua/lsp/lua_ls.lua` file that unfucks `lua_ls` manually
- Conventionally, neovim uses a lot of callbacks and vim.schedules, that raise the indent level. There's an `Async` module that uses dark magic of lua coroutines to turn them callback hell into sugary madness
- Neovim doesn't jibe with russian keyboard layout, so there's 3 utilities to fix it: (1) `Api.rumap` creates vim mappings bilingually (and also async-compatible), (2) `ruscmd` plugin remaps some of built-in keymaps and (3) its setup function contains the manual mappings that attempt to fix it
- This config should work across all machines, including typewriters (machines with weak hardware). Plugins can have `.custom_tags: {"lite"}` to allow plugins to work on typewriters
