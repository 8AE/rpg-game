return function(image_path)
    local MapGenerator = {}
    local Image = love.graphics.newImage(image_path)
    local top_left = love.graphics.newQuad(0, 0, 16, 16, Image:getWidth(), Image:getHeight())

    function MapGenerator:Generate()
        love.graphics.draw(Image, top_left, 0, 0)
    end

    return MapGenerator
end
