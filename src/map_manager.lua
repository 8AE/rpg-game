local constants = require("src.constants")
local MapGenerator = require("src/MapGenerator")

local map_manager = {}

local load_new_map = function()
  map_manager.current_map_table = map_manager.teleportation_queue.current_map_table
  map_manager.current_map = MapGenerator(
    "data/image/texture_sheet.png",
    constants.base_map_path .. map_manager.current_map_table.map_string,
    constants.base_event_path .. map_manager.current_map_table.map_string .. ".json",
    map_manager.teleportation_queue,
    map_manager.player,
    map_manager.current_map_table.next_x,
    map_manager.current_map_table.next_y)
end

map_manager.update = function(dt)
  if map_manager.current_map_table.map_string ~= map_manager.teleportation_queue.current_map_table.map_string then
    load_new_map()
  end
end

map_manager.load = function(teleportation_queue, player)
  map_manager.teleportation_queue = teleportation_queue
  map_manager.current_map_table = teleportation_queue.current_map_table
  map_manager.player = player
  load_new_map()
end

return map_manager
