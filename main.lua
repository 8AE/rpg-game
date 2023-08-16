local MapGenerator = require("src/MapGenerator")
local Player = require("src.player")
local map
local player
local tile_size = 32

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
  local lldebugger = require "lldebugger"
  lldebugger.start()
  local run = love.run
  function love.run(...)
    local f = lldebugger.call(run, false, ...)
    return function(...) return lldebugger.call(f, false, ...) end
  end
end

function love.load()
  map = MapGenerator("lib/image/texture_sheet.png", "lib/map/level1_1")
  player = Player.new("lib/image/characters/main-character.png", 7, 18)
end

function love.update(dt)
  player:update_position_based_on_direction()

  if love.keyboard.isDown("up") then
    player:update_direction_if_not_moving('up')
    if map:canMove(player.x, player.y - tile_size) then
      player:move(player.x, player.y - tile_size)
    end
  end
  if love.keyboard.isDown("down") then
    player:update_direction_if_not_moving('down')
    if map:canMove(player.x, player.y + player.speed, player.direction) then
      player:move(player.x, player.y + tile_size)
    end
  end
  if love.keyboard.isDown("left") then
    player:update_direction_if_not_moving('left')
    if map:canMove(player.x - tile_size, player.y) then
      player:move(player.x - tile_size, player.y)
    end
  end
  if love.keyboard.isDown("right") then
    player:update_direction_if_not_moving('right')
    if map:canMove(player.x + player.speed, player.y, player.direction) then
      player:move(player.x + tile_size, player.y)
    end
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
  love.graphics.print("Player x scaled = " .. math.floor(player.x / tile_size), 0, 10)
  love.graphics.print("Player y = " .. player.y, 0, 20)
  love.graphics.print("Player y scaled = " .. math.floor(player.y / tile_size), 0, 30)
  love.graphics.print("Can i be here? = " .. tostring(map:canMove(player.x, player.y)), 0, 40)
end
