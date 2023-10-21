local constants = require("src.constants")
local rpg_print = require('src.font.rpg_print')

local number_of_items_to_show = 5
local current_item_x = 0
local current_item_y = 0
local selected_item = nil
local current_inventory = {}
local inventory_screen = {
  show_inventory = false
}

local draw_inventory = function(inventory_to_show, x, y)
  local col = 0
  local row = 0
  for _, current_item in ipairs(inventory_to_show) do
    love.graphics.draw(current_item.image_sheet, current_item.icon_quad,
      x - (constants.tile_size * 3) + (col * constants.tile_size),
      y - (constants.tile_size * 4) + (row * constants.tile_size))
    if col >= number_of_items_to_show - 1 then
      row = row + 1
      col = 0
    else
      col = col + 1
    end

    if row >= number_of_items_to_show - 1 then
      return
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

local convert_to_inventory_grid = function(inventory_to_show)
  local new_inventory = {}
  local index = 1
  for i = 1, number_of_items_to_show do
    new_inventory[i] = {} -- Create a new row
    for j = 1, number_of_items_to_show do
      if index <= #inventory_to_show then
        new_inventory[i][j] = inventory_to_show[index]
        index = index + 1
      else
        new_inventory[i][j] = nil -- Fill with nil if no more elements in the 1D table
      end
    end
  end
  return new_inventory
end

local draw_item_information = function(inventory_to_show, x, y)
  rpg_print("Inventory", x - (constants.tile_size * 3) + 10, y - (constants.tile_size * 5) + 10)
  rpg_print("Item", x + (constants.tile_size * 3), y - (constants.tile_size * 5), constants.small_text_scale_factor)
  rpg_print("Description", x + (constants.tile_size * 3), y - (constants.tile_size * 3),
    constants.small_text_scale_factor)

  local grid_inventory = convert_to_inventory_grid(inventory_to_show)
  if grid_inventory[current_item_y + 1][current_item_x + 1] ~= nil then
    rpg_print(
      tostring(grid_inventory[current_item_y + 1][current_item_x + 1].name),
      x + (constants.tile_size * 3),
      y - (constants.tile_size * 4),
      constants.small_text_scale_factor)

    rpg_print(
      tostring(grid_inventory[current_item_y + 1][current_item_x + 1].description),
      x + (constants.tile_size * 3),
      y - (constants.tile_size * 2),
      constants.small_text_scale_factor)
  end
end

local draw_cursor = function(inventory_to_show, x, y)
  love.graphics.push()
  love.graphics.setColor(255, 255, 0)

  love.graphics.rectangle("line", x - (constants.tile_size * 3) + (current_item_x * constants.tile_size),
    y - (constants.tile_size * 4) + (current_item_y * constants.tile_size), constants.tile_size,
    constants.tile_size)

  love.graphics.reset()
  love.graphics.pop()
end

local change_cursor_value_to = function(new_value)
  if new_value >= number_of_items_to_show - 1 then
    new_value = number_of_items_to_show - 1
  elseif new_value < 0 then
    new_value = 0
  end

  return new_value
end

local select_current_item = function()
  local grid_inventory = convert_to_inventory_grid(current_inventory)
  current_item = grid_inventory[current_item_y + 1][current_item_x + 1]
  if current_item ~= nil and selected_item ~= current_item then
    selected_item = grid_inventory[current_item_y + 1][current_item_x + 1]
  else
    selected_item = nil
  end
end

inventory_screen.get_selected_item = function()
  return selected_item
end

inventory_screen.keypressed = function(key)
  if inventory_screen.show_inventory then
    if key == 'right' then
      current_item_x = change_cursor_value_to(current_item_x + 1)
    elseif key == 'left' then
      current_item_x = change_cursor_value_to(current_item_x - 1)
    elseif key == 'down' then
      current_item_y = change_cursor_value_to(current_item_y + 1)
    elseif key == 'up' then
      current_item_y = change_cursor_value_to(current_item_y - 1)
    elseif key == 'return' then
      select_current_item()
    end
  end
end

inventory_screen.inventory_update = function(dt, _inventory_to_show)
  if inventory_screen.show_inventory then
    current_inventory = _inventory_to_show
  end
end

inventory_screen.draw = function(x, y)
  draw_main_screen(x, y)
  draw_item_outline_boxed(x, y)
  draw_inventory(current_inventory, x, y)
  draw_item_information(current_inventory, x, y)
  draw_cursor(current_inventory, x, y)

  -- TODO: draw_trash(inventory_to_show, x, y)
end

return inventory_screen
