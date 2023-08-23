local tile_size = 32
local inventory_screen = {}

local draw_inventory = function(inventory_to_show, x, y)
  for _, item in ipairs(inventory_to_show) do
    love.graphics.draw(item.image_sheet, item.icon_quad, x, y)
  end
end

local draw_main_screen = function(x, y)
  love.graphics.push()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", x - tile_size * 3, y - tile_size * 5, tile_size * 10,
    tile_size * 7)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", x - tile_size * 3, y - tile_size * 5, tile_size * 10,
    tile_size * 7)
  love.graphics.reset()
  love.graphics.pop()
end

inventory_screen.draw = function(inventory_to_show, x, y)
  draw_main_screen(x, y)


  draw_inventory(inventory_to_show, x, y)
end


return inventory_screen
