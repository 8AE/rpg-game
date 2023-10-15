local constants = require("src.constants")
local json = require("src.json.love_json")
local Teleport = require("src.event.teleport")

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
      love.graphics.print(tostring(j - constants.legacy_offset) .. "," .. tostring(i - 1), (j - 1) * constants.tile_size,
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

local draw_events = function(event)
  event:draw()
end

return function(image_path, map_path, event_path)
  local MapGenerator = {}
  local image = love.graphics.newImage(image_path)
  local tile_map = tile_sheet_to_tile_map(image)
  local map_width_and_height, parsed_map_data = parse_file_by_comma(map_path .. '.map')
  local _, parsed_wall_map_data = parse_file_by_comma(map_path .. '.cmap')
  local event_data = json.decode_json(event_path)

  local tele = event_data['move'][1]
  local example_t = Teleport.new(tele.x, tele.y, tele.next_map, tele.next_x, tele.next_y)

  function MapGenerator:draw()
    love.graphics.push()
    draw_map(image, map_width_and_height, parsed_map_data, tile_map)
    -- draw_debug_map(map_width_and_height, parsed_wall_map_data)
    draw_events(example_t)
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
    example_t:update(dt, player_scaled_x, player_scaled_y)
  end

  return MapGenerator
end
