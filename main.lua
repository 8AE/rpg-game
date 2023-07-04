local MapGenerator = require("src/MapGenerator")
local map_generator

function love.load()
  map_generator = MapGenerator("lib/image/texture_sheet.png")
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    w = w + 1
    h = h + 1
  end
end

function love.draw()
  -- love.graphics.setColor(0, 0.4, 0.4)
  -- love.graphics.rectangle("fill", x, y, w, h)
  map_generator.Generate()
end
