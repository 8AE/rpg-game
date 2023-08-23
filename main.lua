local cute = require("lib.cute.cute")
local quad_tile = require("src.quad_tile")
local Item = require("src.item")
local inventory_screen = require("src.inventory_screen")
local MapGenerator = require("src/MapGenerator")
local Player = require("src.player")

local map
local player
local example_item
local tile_size = 32

local show_inventory

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
  local lldebugger = require "lldebugger"
  lldebugger.start()
  local run = love.run
  function love.run(...)
    local f = lldebugger.call(run, false, ...)
    return function(...) return lldebugger.call(f, false, ...) end
  end
end

local make_item = function(image_path)
  local image = love.graphics.newImage(image_path)
  example_item = Item.new(image, quad_tile(image, 0, 0), "example", "this is an example")
end

function love.load(args)
  cute.go(args)
  map = MapGenerator("data/image/texture_sheet.png", "data/map/level1_1")
  player = Player.new("data/image/characters/main-character.png", 7, 18)
  make_item("data/image/weapon_cells.png")
  show_inventory = false
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

local print_debug_information = function(player)
  love.graphics.print("Player x = " .. player.x, 0, 0)
  love.graphics.print("Player x scaled = " .. math.floor(player.x / tile_size), 0, 10)
  love.graphics.print("Player y = " .. player.y, 0, 20)
  love.graphics.print("Player y scaled = " .. math.floor(player.y / tile_size), 0, 30)
  love.graphics.print("Can i be here? = " .. tostring(map:canMove(player.x, player.y)), 0, 40)
  love.graphics.print("Inventory is shown = " .. tostring(show_inventory), 0, 50)
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(2, 2)
  love.graphics.translate(-player.x + love.window.getPosition(), -player.y + love.window.getPosition())
  map:draw()
  -- map.debug_draw_tile(player.x, player.y)
  player:draw()
  table.insert(player.inventory, example_item)

  if show_inventory then
    inventory_screen.draw(player.inventory, player.x, player.y)
  end
  love.graphics.pop()

  print_debug_information(player)

  cute.draw(love.graphics)
end

love.keypressed = function(key)
  cute.keypressed(key)
  if key == 'i' then
    show_inventory = not show_inventory
  end
end
