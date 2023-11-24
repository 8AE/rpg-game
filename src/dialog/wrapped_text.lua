local rpg_print = require('src.font.rpg_print')
local character_spacing_x = 13
local character_spacing_y = 17
local max_character_length = 27

return function(text, x, y, scale_factor)
    scale_factor = scale_factor or 1
    love.graphics.push()

    local i = 0
    local j = 0
    for c in text:gmatch "." do
        rpg_print(c, (x + (character_spacing_x * i)), y + (character_spacing_y * j), scale_factor)
        i = i + 1;
        if i > max_character_length then
            i = 0
            j = j + 1
        end
    end
    love.graphics.reset()
    love.graphics.pop()
end
