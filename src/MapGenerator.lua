local tile_size = 32

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
            love.graphics.draw(image, tile_data[map_data[i][j] + 1], (j - 1) * tile_size, (i - 1) * tile_size)
        end
    end
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
    local map_width_and_height, parsed_map_data = parse_file_by_comma(map_path)

    function MapGenerator:Generate()
        love.graphics.push()
        love.graphics.scale(1, 1)
        draw_map(image, map_width_and_height, parsed_map_data, tile_map)
        love.graphics.pop()
    end

    return MapGenerator
end