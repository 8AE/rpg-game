local constants = require("src.constants")
local number_of_items_to_show = 5
local inventory_screen = {
  show_inventory = false
}

local draw_inventory = function(inventory_to_show, x, y)
  -- for _, item in ipairs(inventory_to_show) do
  --   love.graphics.draw(item.image_sheet, item.icon_quad, x, y)
  -- end

  for i = 0, number_of_items_to_show - 1, 1 do
    for j = 0, number_of_items_to_show - 1, 1 do
      local current_item = inventory_to_show[i + j + 1]
      if current_item ~= nil then
        love.graphics.draw(current_item.image_sheet, current_item.icon_quad,
          x - (constants.tile_size * 3) + (i * constants.tile_size),
          y - (constants.tile_size * 4) + (j * constants.tile_size))
      end
    end
  end
end

local draw_item_outline_boxed = function(x, y)
  love.graphics.push()
  love.graphics.setColor(255, 255, 255)

  for i = 0, number_of_items_to_show - 1, 1 do
    for j = 0, number_of_items_to_show - 1, 1 do
      love.graphics.rectangle("line", x - (constants.tile_size * 3) + (i * constants.tile_size),
        y - (constants.tile_size * 4) + (j * constants.tile_size), constants.tile_size,
        constants.tile_size)
    end
  end

  love.graphics.reset()
  love.graphics.pop()
end

local draw_main_screen = function(x, y)
  love.graphics.push()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", x - constants.tile_size * 3, y - constants.tile_size * 5, constants.tile_size * 10,
    constants.tile_size * 7)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", x - constants.tile_size * 3, y - constants.tile_size * 5, constants.tile_size * 10,
    constants.tile_size * 7)
  love.graphics.reset()
  love.graphics.pop()
end

inventory_screen.draw = function(inventory_to_show, x, y)
  draw_main_screen(x, y)
  draw_item_outline_boxed(x, y)
  draw_inventory(inventory_to_show, x, y)
end

return inventory_screen
