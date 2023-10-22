local quad_tile = require("src.quad_tile")
local Item = require("src.item")
local inventory_screen = require("src.inventory_screen")
local hud = require("src.hud")
local Player = require("src.player")
local constants = require("src.util.constants")
local version = require("version")
local teleportation_queue = require("src.event.teleportation_queue")
local map_manager = require("src.map_manager")
local rpg_print = require('src.font.rpg_print')

local app = {}

local player
local example_item
local example_item_2

local starting_x = 17
local starting_y = 21

local make_item = function(image_path)
  local image = love.graphics.newImage(image_path)
  example_item = Item.new(image, quad_tile(image, 0, 0), "example", "this is an example")
  example_item_2 = Item.new(image, quad_tile(image, 0, 1), "example 2", "this is an example 2")
end

local standard_movement_update = function(dt)
  if not inventory_screen.show_inventory then
    player:update_position_based_on_direction()

    if love.keyboard.isDown("up") then
      player:update_direction_if_not_moving('up')
      if map_manager.current_map:canMove(player.x, player.y - constants.tile_size) then
        player:move(player.x, player.y - constants.tile_size)
      end
    end
    if love.keyboard.isDown("down") then
      player:update_direction_if_not_moving('down')
      if map_manager.current_map:canMove(player.x, player.y + player.speed, player.direction) then
        player:move(player.x, player.y + constants.tile_size)
      end
    end
    if love.keyboard.isDown("left") then
      player:update_direction_if_not_moving('left')
      if map_manager.current_map:canMove(player.x - constants.tile_size, player.y) then
        player:move(player.x - constants.tile_size, player.y)
      end
    end
    if love.keyboard.isDown("right") then
      player:update_direction_if_not_moving('right')
      if map_manager.current_map:canMove(player.x + player.speed, player.y, player.direction) then
        player:move(player.x + constants.tile_size, player.y)
      end
    end
  end
end

function app.load(args)
  player = Player.new("data/image/characters/main-character.png")
  teleportation_queue.load('level1_1', starting_x, starting_y)
  map_manager.load(teleportation_queue, player)
  make_item("data/image/weapon_cells.png")
  table.insert(player.inventory, example_item)
  table.insert(player.inventory, example_item_2)
end

local print_debug_information = function(player)
  rpg_print("Player x = " .. player.x, 0, 0)
  rpg_print("Player x scaled = " .. math.floor(player.x / constants.tile_size), 0, 20)
  rpg_print("Player y = " .. player.y, 0, 40)
  rpg_print("Player y scaled = " .. math.floor(player.y / constants.tile_size), 0, 60)
  rpg_print("Can i be here? = " .. tostring(map_manager.current_map:canMove(player.x, player.y)), 0, 80)
  rpg_print("Inventory is shown = " .. tostring(inventory_screen.show_inventory), 0, 100)
  rpg_print(
    "Version " ..
    tostring(version.major) ..
    "." .. tostring(version.minor) .. "." .. tostring(version.patch) .. "." .. tostring(version.package), 0, 120)
end

local draw_main_screen = function()
  love.graphics.push()

  love.graphics.scale(constants.zoom, constants.zoom)
  love.graphics.translate(-player.x + (love.graphics.getWidth() / 4), -player.y + (love.graphics.getHeight() / 4))
  map_manager.current_map:draw()
  player:draw()

  love.graphics.pop()
end

local draw_hud = function()
  love.graphics.push()
  love.graphics.scale(constants.zoom, constants.zoom)

  hud.draw(player.equiped_item, 100, 0, 0)

  love.graphics.pop()
end

local draw_inventory = function()
  love.graphics.push()
  love.graphics.scale(constants.zoom, constants.zoom)

  if inventory_screen.show_inventory then
    inventory_screen.draw(
      love.graphics.getWidth() / (2.5 * constants.zoom),
      love.graphics.getHeight() / (1.5 * constants.zoom))
  end

  love.graphics.pop()
end

local draw_debug_content = function()
  love.graphics.push()
  love.graphics.scale(constants.zoom, constants.zoom)
  print_debug_information(player)

  -- map_manager.current_map.debug_draw_tile(player.x, player.y)
  love.graphics.pop()
end

local player_based_update = function(dt)
  player.equiped_item = inventory_screen.get_selected_item()
end

local map_update = function(dt)
  map_manager.current_map:update(dt, player:get_scaled_x(), player:get_scaled_y())
  map_manager.update(dt)
end

function app.draw()
  draw_main_screen()
  draw_hud()
  draw_inventory()
  -- draw_debug_content()
end

function app.update(dt)
  standard_movement_update(dt)
  inventory_screen.inventory_update(dt, player.inventory)
  player_based_update(dt)
  teleportation_queue.update(dt)
  map_update(dt)
end

app.keypressed = function(key)
  inventory_screen.keypressed(key)

  if key == 'i' then
    inventory_screen.show_inventory = not inventory_screen.show_inventory
  end
end

return app
