local MapGenerator = require("src/MapGenerator")
local Player = require("src/Player")
local map_generator
local player

function love.load()
  map_generator = MapGenerator("lib/image/texture_sheet.png", "lib/map/test.map")
  player = Player("lib/image/characters.png", 0, 0)
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    player.y = player.y - 1
  end
  if love.keyboard.isDown("down") then
    player.y = player.y + 1
  end
  if love.keyboard.isDown("left") then
    player.x = player.x - 1
  end
  if love.keyboard.isDown("right") then
    player.x = player.x + 1
  end
end

function love.draw()
  map_generator.draw()
  player.draw()
  love.graphics.print("Player x = " .. player.x, 0, 0)
  love.graphics.print("Player y = " .. player.y, 0, 10)
end
