local MapGenerator = require("src/MapGenerator")
local Player = require("src/Player")
local map
local player

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
  local lldebugger = require "lldebugger"
  lldebugger.start()
  local run = love.run
  function love.run(...)
    local f = lldebugger.call(run, false, ...)
    return function(...) return lldebugger.call(f, false, ...) end
  end
end

local function old_update()
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

function love.load()
  map = MapGenerator("lib/image/texture_sheet.png", "lib/map/level1_1")
  player = Player("lib/image/characters/main-character.png", 7, 18)
  -- love.update = old_update
end

function love.update(dt)
  if love.keyboard.isDown("up") then
    if map:canMove(player.x, player.y - 32) then
      player.y = player.y - player.speed
    end
    player.direction = 'up'
  end
  if love.keyboard.isDown("down") then
    if map:canMove(player.x, player.y + player.speed) then
      player.y = player.y + player.speed
    end
    player.direction = 'down'
  end
  if love.keyboard.isDown("left") then
    if map:canMove(player.x - 32, player.y) then
      player.x = player.x - player.speed
    end
    player.direction = 'left'
  end
  if love.keyboard.isDown("right") then
    if map:canMove(player.x + player.speed, player.y) then
      player.x = player.x + player.speed
    end
    player.direction = 'right'
  end
end

function love.draw()
  love.graphics.push()
  love.graphics.translate(-player.x, -player.y)
  map:draw()
  map.debug_draw_tile(player.x, player.y)
  player:draw()
  love.graphics.pop()

  love.graphics.print("Player x = " .. player.x, 0, 0)
  love.graphics.print("Player x scaled = " .. math.floor(player.x / 32), 0, 10)
  love.graphics.print("Player y = " .. player.y, 0, 20)
  love.graphics.print("Player y scaled = " .. math.floor(player.y / 32), 0, 30)
  love.graphics.print("Can i be here? = " .. tostring(map:canMove(player.x, player.y)), 0, 40)
end
