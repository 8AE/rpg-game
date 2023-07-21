local MapGenerator = require("src/MapGenerator")
local Player = require("src/Player")
local map_generator
local player

function love.load()
  map_generator = MapGenerator("lib/image/texture_sheet.png", "lib/map/test.map")
  player = Player("lib/image/characters/main-character.png", 7, 18)
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    player.y = player.y - player.speed
    player.direction = 'up'
  end
  if love.keyboard.isDown("down") then
    player.y = player.y + player.speed
    player.direction = 'down'
  end
  if love.keyboard.isDown("left") then
    player.x = player.x - player.speed
    player.direction = 'left'
  end
  if love.keyboard.isDown("right") then
    player.x = player.x + player.speed
    player.direction = 'right'
  end
end

function love.draw()
  love.graphics.push()
  love.graphics.translate(-player.x, -player.y)
  map_generator.draw()
  player:draw()
  love.graphics.pop()

  love.graphics.print("Player x = " .. player.x, 0, 0)
  love.graphics.print("Player y = " .. player.y, 0, 10)
end
