local rpg_print = require('src.font.rpg_print')
local character_spacing = 13
local max_character_length = 15

return function(text, x, y, scale_factor)
    scale_factor = scale_factor or 1
    love.graphics.push()
    for i = 1, #text, 1 do
        local c = text:sub(i, i)
        rpg_print(c, (x + (character_spacing * (i - 1))), y, scale_factor)
    end
    love.graphics.reset()
    love.graphics.pop()
end
