local ru_char_map = {
  ["!"] = '!',
  ["@"] = '"',
  ["#"] = '№',
  ["$"] = ';',
  ["%"] = '%',
  ["^"] = ':',
  ["&"] = '?',
  ["*"] = '*',
  ["("] = '(',
  [")"] = ')',
  ["_"] = '_',
  ["+"] = '+',
  ["Q"] = 'Й',
  ["W"] = 'Ц',
  ["E"] = 'У',
  ["R"] = 'К',
  ["T"] = 'Е',
  ["Y"] = 'Н',
  ["U"] = 'Г',
  ["I"] = 'Ш',
  ["O"] = 'Щ',
  ["P"] = 'З',
  ["{"] = 'Х',
  ["}"] = 'Ъ',
  ["|"] = '/',
  ["A"] = 'Ф',
  ["S"] = 'Ы',
  ["D"] = 'В',
  ["F"] = 'А',
  ["G"] = 'П',
  ["H"] = 'Р',
  ["J"] = 'О',
  ["K"] = 'Л',
  ["L"] = 'Д',
  [":"] = 'Ж',
  ["\""] = 'Э',
  ["Z"] = 'Я',
  ["X"] = 'Ч',
  ["C"] = 'С',
  ["V"] = 'М',
  ["B"] = 'И',
  ["N"] = 'Т',
  ["M"] = 'Ь',
  ["<"] = 'Б',
  [">"] = 'Ю',
  ["?"] = ',',
  ["q"] = 'й',
  ["w"] = 'ц',
  ["e"] = 'у',
  ["r"] = 'к',
  ["t"] = 'е',
  ["y"] = 'н',
  ["u"] = 'г',
  ["i"] = 'ш',
  ["o"] = 'щ',
  ["p"] = 'з',
  ["["] = 'х',
  ["]"] = 'ъ',
  ["\\"] = '\\',
  ["a"] = 'ф',
  ["s"] = 'ы',
  ["d"] = 'в',
  ["f"] = 'а',
  ["g"] = 'п',
  ["h"] = 'р',
  ["j"] = 'о',
  ["k"] = 'л',
  ["l"] = 'д',
  [";"] = 'ж',
  ["'"] = 'э',
  ["z"] = 'я',
  ["x"] = 'ч',
  ["c"] = 'с',
  ["v"] = 'м',
  ["b"] = 'и',
  ["n"] = 'т',
  ["m"] = 'ь',
  [","] = 'б',
  ["."] = 'ю',
  ["/"] = '.',
}

local ruscmd_collisions = {
  ZZ = true,
  gd = true,
}

--- vim.keymap.set but supporting russian layout & async functions
--- @param mode string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
--- @param lhs string           Left-hand side |{lhs}| of the mapping.
--- @param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
--- @param opts? vim.keymap.set.Opts
return function(mode, lhs, rhs, opts)
  if type(rhs) == "function" then
    rhs = Api.async(rhs)
  end

  vim.keymap.set(mode, lhs, rhs, opts)

  if ruscmd_collisions[lhs] then return end

  local translation = ""
  local is_in_brackets = false
  for character in lhs:gmatch(".") do
    if character == "<" then
      is_in_brackets = true
    elseif character == ">" then
      is_in_brackets = false
    elseif not is_in_brackets then
      character = ru_char_map[character] or character
    end
    translation = translation .. character
  end

  vim.keymap.set(mode, translation, rhs, opts)
end
