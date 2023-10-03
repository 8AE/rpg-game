local cute = require("lib.cute.cute")
local constants = require("src.constants")
local Player = require("src.player")

local some_x = 1
local some_y = 2

notion("Player position is correct on init", function()
  local player = Player.new("data/image/characters/main-character.png", some_x, some_y)

  check(player:get_scaled_x()).is(some_x)
  check(player:get_scaled_y()).is(some_y)
end)

notion("Player should be facing down on init", function()
  local player = Player.new("data/image/characters/main-character.png", some_x, some_y)

  check(player:get_scaled_y()).is(some_y)
end)

notion("Player should be able to move", function()
  local player = Player.new("data/image/characters/main-character.png", some_x, some_y)

  check(player:get_scaled_x()).is(some_x)
  check(player:get_scaled_y()).is(some_y)

  player:move(some_x + constants.tile_size, some_y + constants.tile_size)
  check(player.moving).is(true)
end)

notion("Player should have its direction updated only when its not moving", function()
  local player = Player.new("data/image/characters/main-character.png", some_x, some_y)

  check(player.direction).is("down")
end)
