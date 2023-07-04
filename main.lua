local MapGenerator = require("src/MapGenerator")
local map_generator

function love.load()
  map_generator = MapGenerator("lib/image/texture_sheet.png")
end

function love.update(dt)
  if love.keyboard.isDown("up") then

  end
end

function love.draw()
  map_generator.Generate()
end
