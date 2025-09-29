local luasnip = require("luasnip")
local language_styles = require("language_styles")
local snippet = luasnip.parser.parse_snipmate


local snippets = {}

snippets.init = function()
  luasnip.add_snippets('lua', {
    snippet(
      "sc",
      [[
        --- @type scene|table
        $1 = {
          --- @param self scene|table
          --- @param dt number
          start_predicate = function(self, dt)
            return $2
          end,

          --- @param self scene|table
          run = function(self)
            $0
          end,
        },
      ]]
    ),
    snippet(
      "scc",
      [[
        --- @type scene|table
        $1 = {
          characters = {
            $2
          },

          --- @param self scene|table
          --- @param dt number
          --- @param ch runner_characters
          --- @param ps runner_positions
          start_predicate = function(self, dt, ch, ps)
            return $3
          end,

          --- @param self scene|table
          --- @param ch runner_characters
          --- @param ps runner_positions
          run = function(self, ch, ps)
            $0
          end,
        },
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
      "ac",
      [[
        $1 = {
          codename = "$1",
          get_availability = function(self, entity)
            return $2
          end,
          _run = function(self, entity)
            $3
          end,
        }$0
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

  for language, data in pairs(language_styles) do
    local tab = string.rep(" ", data.tab)
    luasnip.add_snippets(language, {
      snippet("{", ([[
        {
        %s$1
        }$0
      ]]):format(tab)),
      snippet("(", ([[
        (
        %s$1
        )$0
      ]]):format(tab)),
      snippet("[", ([[
        [
        %s$1
        ]$0
      ]]):format(tab)),
    })
  end
end

return snippets
