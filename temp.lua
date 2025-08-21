local temp = {}

--- @class 
local methods = {}
local mt = {__index = methods}


--- @return 
temp.new = function()
  return setmetatable({
    
  }, mt)
end

Ldump.mark(temp, {}, ...)
return temp
