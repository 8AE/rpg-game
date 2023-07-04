local tile_size = 32

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

return function(image_path)
    local MapGenerator = {}
    local image = love.graphics.newImage(image_path)
    local tile_map = tile_sheet_to_tile_map(image)
    function MapGenerator:Generate()
        love.graphics.push()
        love.graphics.scale(4, 4)
        love.graphics.draw(image, tile_map[1], 0, 0)
        love.graphics.draw(image, tile_map[2], tile_size, 0)
        love.graphics.draw(image, tile_map[3], tile_size * 2, 0)
        love.graphics.draw(image, tile_map[3], tile_size * 3, 0)
        love.graphics.pop()
    end

    return MapGenerator
end
