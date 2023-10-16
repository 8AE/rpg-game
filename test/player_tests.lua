local cute = require("lib.cute.cute")
local Player = require("src.player")

notion("Player should be facing down on init", function()
  local player = Player.new("data/image/characters/main-character.png")

  check(player.direction).is("down")
end)
