local luasnip = require("luasnip")
local language_styles = require("language_styles")
local snippet = luasnip.parser.parse_snipmate


local snippets = {}

snippets.init = function()
  luasnip.add_snippets('lua', {
    snippet(
      "sc",
      [[
        {
          condition = function(self, name, dt)
            return $2
          end,

          run = function(self, name)
            $0
          end,
        },
      ]]
    ),
    luasnip.s("cs", {
      luasnip.d(1, function(args, parent)
        local env = parent.snippet.env
        local line = (env and env.TM_CURRENT_LINE) or vim.api.nvim_get_current_line()
        
        local key = line:match("([%w_]+)%s*=%s*cs$") or line:match("([%w_]+)%s*=%s*$")
        local default_val = key and key:gsub("^_", "") or ""

        return luasnip.sn(nil, require("luasnip.extras.fmt").fmt([[
          cutscene.make {{
            enabled = {},
            screenplay = "assets/screenplay/{}.ms",
            characters = {{
              {}
            }},

            _condition = function(self, dt, ch, ps)
              return {}
            end,

            _run = function(self, ch, ps, sp)
              {}
            end,
          }},{}
        ]], {
          luasnip.i(1),
          luasnip.i(2, default_val),
          luasnip.i(3),
          luasnip.i(4),
          luasnip.i(5),
          luasnip.i(0),
        }))
      end)
    }),
    snippet(
      "spl",
      [[
        sp:lines()$0
      ]]
    ),
    snippet(
      "spb",
      [[
        sp:start_branch($1)
          $0
        sp:finish_branch()
      ]]
    ),
    snippet("spbs", [[
      sp:start_branches()
        $0
      sp:finish_branches()
    ]]),
    snippet("sps", [[
      sp:start_single_branch($1)
        $2
      sp:finish_single_branch()$0
    ]]),
    snippet("spa", [[
      sp:start_single_branch(State.player:ability_check($1) and 1 or 2)
        $2
      sp:finish_single_branch()$0
    ]]),
    snippet(
      "spos",
      [[
        api.options(sp:start_options())
          $1
        sp:finish_options()$0
      ]]
    ),
    snippet(
      "spo",
      [[
        sp:start_option($1)
          $0
        sp:finish_option()
      ]]
    ),
    snippet(
      "ac",
      [[
        State.player:ability_check($1)$0
      ]]
    ),
    snippet(
      "fn",
      [[
        function($1) return $2 end$0
      ]]
    ),
    snippet(
      "fnt",
      [[
        function($1)
          $2
        end$0
      ]]
    ),
    snippet(
      "fnt,",
      [[
        function($1)
          $2
        end,$0
      ]]
    ),
    snippet(
      "de",
      [[
        describe("$1", function()
          $2
        end)$0
      ]]
    ),
    snippet(
      "it",
      [[
        it("$1", function()
          $2
        end)$0
      ]]
    ),
    snippet(
      "do",
      [[
        do
          $1
        end$0
      ]]
    ),
    snippet(
      "[[",
      [=[
        [[
          $1
        ]]$0
      ]=]
    ),
  })

  luasnip.add_snippets("c", {
    snippet("for", [[
      for (size_t $1 = 0; $1 < $2; $1++) {
          $3
      }$0
    ]]),

    snippet("st", [[
      typedef struct {
          $2
      } $1;$0
    ]]),

    snippet("en", [[
      typedef enum {
          $2
      } $1;$0
    ]])
  })

  luasnip.add_snippets("zig", {
    snippet("pp", [[std.debug.print("$1\n", .{$2});$0]]),
  })

  local pair_chars = {
    {"{", "}", true},
    {"(", ")", true},
    {"[", "]", true},
    {"<", ">", false},
    -- (don't work)
    -- {"[[", "]]", true},
    -- {'"', '"', false},
    -- {"'", "'", false},
  }

  for language, data in pairs(language_styles) do
    local tab = data.uses_tabs and "\t" or string.rep(" ", data.tab)
    for _, t in ipairs(pair_chars) do
      local start, finish, expands = unpack(t)

      if expands then
        luasnip.add_snippets(language, {
          snippet(start, ([[
            %s
            %s$1
            %s$0
          ]]):format(start, tab, finish)),

          snippet(start .. "c", ([[
            %s
            %s$1
            %s,$0
          ]]):format(start, tab, finish)),

          snippet(start .. "s", ([[
            %s
            %s$1
            %s;$0
          ]]):format(start, tab, finish))
        })
      end

      luasnip.add_snippets(language, {
        snippet(start .. finish,        start .. "$1" .. finish .. "$0"),
        snippet(start .. finish .. "c", start .. "$1" .. finish .. ",$0"),
        snippet(start .. finish .. "s", start .. "$1" .. finish .. ";$0")
      })
    end
  end
end

return snippets
