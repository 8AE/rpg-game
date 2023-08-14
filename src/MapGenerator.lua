local tile_size = 32
local legacy_offset = 1

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
      love.graphics.draw(image, tile_data[map_data[i][j] + legacy_offset], (j - legacy_offset) * tile_size,
        (i - legacy_offset) * tile_size)
    end
  end
end

local function draw_tile(image, map_width_and_height, map_data, tile_data, x, y)
  love.graphics.draw(image, tile_data[map_data[y + 1][x + 1] + legacy_offset], (x) * tile_size,
    (y) * tile_size)

  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("line", (x) * tile_size, (y) * tile_size, tile_size, tile_size)
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
      love.graphics.rectangle("line", (j - legacy_offset) * tile_size, (i - 1) * tile_size, tile_size, tile_size)
      love.graphics.print(tostring(j - legacy_offset) .. "," .. tostring(i - 1), (j - 1) * tile_size,
        (i - legacy_offset) * tile_size)
    end
  end
  love.graphics.reset()
end

local function tile_sheet_to_tile_map(image)
  local tile_map = {}
  for i = 0, (image:getWidth() / tile_size) - 1, 1 do
    for j = 0, (image:getHeight() / tile_size) - 1, 1 do
      table.insert(tile_map,
        love.graphics.newQuad(j * 32, i * 32, tile_size, tile_size, image:getWidth(), image:getHeight()))
    end
  end
  return tile_map
end

return function(image_path, map_path)
  local MapGenerator = {}
  local image = love.graphics.newImage(image_path)
  local tile_map = tile_sheet_to_tile_map(image)
  local map_width_and_height, parsed_map_data = parse_file_by_comma(map_path .. '.map')
  local _, parsed_wall_map_data = parse_file_by_comma(map_path .. '.cmap')

  function MapGenerator:draw()
    love.graphics.push()
    love.graphics.scale(2, 2)
    draw_map(image, map_width_and_height, parsed_map_data, tile_map)
    draw_debug_map(map_width_and_height, parsed_wall_map_data)
    love.graphics.pop()
  end

  function MapGenerator.debug_draw_tile(target_x, target_y)
    love.graphics.push()
    love.graphics.scale(2, 2)
    target_x = math.floor(target_x / tile_size)
    target_y = math.floor(target_y / tile_size)
    draw_tile(image, map_width_and_height, parsed_map_data, tile_map, target_x, target_y)
    love.graphics.pop()
  end

  function MapGenerator:canMove(target_x, target_y)
    target_x = math.floor(target_x / tile_size)
    target_y = math.floor(target_y / tile_size)
    if parsed_wall_map_data[target_y + 1][target_x + 1] == 1 then
      return false
    else
      return true
    end
  end

  return MapGenerator
end
