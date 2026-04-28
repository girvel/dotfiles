local luasnip = require("luasnip")
local language_styles = require("language_styles")
local snippet = luasnip.parser.parse_snipmate


local snippets = {}

snippets.init = function()
  luasnip.add_snippets('lua', {
    snippet(
      "sc",
      [[
        --- @type scene
        $1 = {
          condition = function(self, name, dt)
            return $2
          end,

          run = function(self, name)
            $0
          end,
        },
      ]]
    ),
    snippet(
      "cs",
      [[
        $1 = cutscene.make {
          enabled = $2,
          screenplay = "assets/screenplay/$3.ms",
          characters = {
            $4
          },

          condition = function(self, dt, ch, ps)
            return $5
          end,

          run = function(self, ch, ps, sp)
            $0
          end,
        },
      ]]
    ),
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
    snippet(
      "spbs",
      [[
        sp:start_branches()
          $0
        sp:finish_branches()
      ]]
    ),
    snippet(
      "sps",
      [[
        sp:start_single_branch($1)
          $0
        sp:finish_single_branch()
      ]]
    ),
    snippet(
      "spos",
      [[
        api.options(sp:start_options())
          $0
        sp:finish_options()
      ]]
    ),
    snippet(
      "spoi",
      [[
        if api.options(sp:start_options()) == $1 then return end
        sp:finish_options()$0
      ]]
    ),
    snippet(
      "spon",
      [[
        if api.options(sp:start_options()) ~= $1 then return end
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
        ch.player:ability_check($1)$0
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
    snippet(
      "for",
      [[
        for (size_t $1 = 0; $1 < $2; $1++) {
            $3
        }$0
      ]]
    ),
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
