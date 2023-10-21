local constants = require("src.constants")
local number_scaling = require("src.util.number_scaling")
local Event_Manager = require("src.event.event_manager")
local rpg_print = require('src.font.rpg_print')

local function parse_file_by_comma(filePath)
  local content, size = love.filesystem.read(filePath) -- Read the file using Love2D's Filesystem module
  if not content then
    error("no file " .. filePath)
  end

  local map_data = {}
  local map_height_and_width = {}

  for line in content:gmatch("[^\r\n]+") do
    if line:find(",") then
      local elements = {}

      for element in line:gmatch("[^,]+") do
        table.insert(elements, tonumber(element))
      end

      table.insert(map_data, elements)
    else
      table.insert(map_height_and_width, tonumber(line))
    end
  end

  return map_height_and_width, map_data
end


local function draw_map(image, map_width_and_height, map_data, tile_data)
  for i = 1, map_width_and_height[1], 1 do
    for j = 1, map_width_and_height[2], 1 do
      love.graphics.draw(image, tile_data[map_data[i][j] + constants.legacy_offset],
        (j - constants.legacy_offset) * constants.tile_size,
        (i - constants.legacy_offset) * constants.tile_size)
    end
  end
end

local function draw_tile(image, map_width_and_height, map_data, tile_data, x, y)
  love.graphics.draw(image, tile_data[map_data[y + 1][x + 1] + constants.legacy_offset], (x) * constants.tile_size,
    (y) * constants.tile_size)

  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("line", (x) * constants.tile_size, (y) * constants.tile_size, constants.tile_size,
    constants.tile_size)
  love.graphics.reset()
end

local function draw_debug_map(map_width_and_height, map_data)
  for i = 1, map_width_and_height[1], 1 do
    for j = 1, map_width_and_height[2], 1 do
      if map_data[i][j] == 1 then
        love.graphics.setColor(255, 0, 0)
      else
        love.graphics.setColor(0, 255, 0)
      end
      love.graphics.rectangle("line", (j - constants.legacy_offset) * constants.tile_size, (i - 1) * constants.tile_size,
        constants.tile_size, constants.tile_size)
      rpg_print(tostring(j - constants.legacy_offset) .. "," .. tostring(i - 1), (j - 1) * constants.tile_size,
        (i - constants.legacy_offset) * constants.tile_size)
    end
  end
  love.graphics.reset()
end

local function tile_sheet_to_tile_map(image)
  local tile_map = {}
  for i = 0, (image:getWidth() / constants.tile_size) - 1, 1 do
    for j = 0, (image:getHeight() / constants.tile_size) - 1, 1 do
      table.insert(tile_map,
        love.graphics.newQuad(j * constants.tile_size, i * constants.tile_size, constants.tile_size, constants.tile_size,
          image:getWidth(),
          image:getHeight()))
    end
  end
  return tile_map
end

return function(image_path, map_path, event_path, teleportation_queue, player, start_x, start_y)
  local MapGenerator = {}
  local image = love.graphics.newImage(image_path)
  local tile_map = tile_sheet_to_tile_map(image)
  local map_width_and_height, parsed_map_data = parse_file_by_comma(map_path .. '.map')
  local _, parsed_wall_map_data = parse_file_by_comma(map_path .. '.cmap')
  local event_manager = Event_Manager.new(teleportation_queue, event_path)

  player.x = number_scaling.scaled_to_real(start_x)
  player.target_x = player.x
  player.y = number_scaling.scaled_to_real(start_y)
  player.target_y = player.y

  function MapGenerator:draw()
    love.graphics.push()
    draw_map(image, map_width_and_height, parsed_map_data, tile_map)
    -- draw_debug_map(map_width_and_height, parsed_wall_map_data)
    event_manager:draw()
    love.graphics.pop()
  end

  function MapGenerator.debug_draw_tile(target_x, target_y)
    love.graphics.push()
    love.graphics.scale(2, 2)
    target_x = math.floor(target_x / constants.tile_size)
    target_y = math.floor(target_y / constants.tile_size)
    draw_tile(image, map_width_and_height, parsed_map_data, tile_map, target_x, target_y)
    love.graphics.pop()
  end

  function MapGenerator:canMove(target_x, target_y, player_direction)
    target_x = math.floor(target_x / constants.tile_size)
    target_y = math.floor(target_y / constants.tile_size)
    if parsed_wall_map_data[target_y + 1][target_x + 1] == 1 or
        player_direction == 'right' and parsed_wall_map_data[target_y + 1][target_x + 2] == 1 or
        player_direction == 'down' and parsed_wall_map_data[target_y + 2][target_x + 1] == 1 then
      return false
    else
      return true
    end
  end

  function MapGenerator:update(dt, player_scaled_x, player_scaled_y)
    event_manager:update(dt, player_scaled_x, player_scaled_y)
  end

  return MapGenerator
end
