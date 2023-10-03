local constants = require("src.constants")
local hud = {}

local equiped_item_box_x = 10
local equiped_item_box_y = 10
local equiped_item_box_size_width = constants.tile_size
local equiped_item_box_size_height = equiped_item_box_size_width
local health_text_x = equiped_item_box_x + constants.tile_size + 5
local health_text_y = 10

local draw_equiped_item = function(equiped_item, x, y)
    love.graphics.push()
    love.graphics.setColor(0, 0, 0)

    love.graphics.rectangle("fill", x + equiped_item_box_x, y + equiped_item_box_y, equiped_item_box_size_width,
        equiped_item_box_size_height)

    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", x + equiped_item_box_x, y + equiped_item_box_y, equiped_item_box_size_width,
        equiped_item_box_size_height)

    if equiped_item then
        love.graphics.draw(equiped_item.image_sheet, equiped_item.icon_quad,
            x + equiped_item_box_x,
            y + equiped_item_box_y)
    end

    love.graphics.reset()
    love.graphics.pop()
end

local draw_health = function(health, x, y)
    love.graphics.push()
    love.graphics.setColor(255, 0, 0)

    love.graphics.print("Health: " .. tostring(health), x + (health_text_x), y + health_text_y)

    love.graphics.reset()
    love.graphics.pop()
end

hud.draw = function(equiped_item, health, x, y)
    draw_equiped_item(equiped_item, x, y)
    draw_health(health, x, y)
end

return hud
