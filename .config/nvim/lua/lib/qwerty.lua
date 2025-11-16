local qwerty = {}

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

local exceptions = {
  "C-",
  "M-",
  "S-",
  "BS",
  "leader",
  "cmd",
  "Space",
  "CR",
  "Esc",
  "Left",
  "Right",
  "Up",
  "Down",
  "<",
  ">",
}

--- @param source string
--- @return string
qwerty.translate = function(source)
  local translation = ""

  local i = 1
  while true do
    for _, ex in ipairs(exceptions) do
      if vim.startswith(source:sub(i), ex) then
        translation = translation .. ex
        i = i + #ex
        goto continue
      end
    end

    do
      local character = source:sub(i, i)
      translation = translation .. (ru_char_map[character] or character)
      i = i + 1
    end

    ::continue::
    if i > #source then break end
  end
  return translation
end

return qwerty
