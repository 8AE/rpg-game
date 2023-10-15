local constants = require("src.constants")
local teleportation_queue = {}

local queue_is_empty = function()
  return next(teleportation_queue.next_map) == nil
end

teleportation_queue.next_map = {}

teleportation_queue.add_to_map_transition = function(next_map_table)
  if not teleportation_queue.next_map[next_map_table.map_string] then
    table.insert(teleportation_queue.next_map, next_map_table)
  end
end

teleportation_queue.update = function(dt)
  if not queue_is_empty() then
    teleportation_queue.current_map_table = table.remove(teleportation_queue.next_map, 1)
  end
end

teleportation_queue.load = function(first_map_string, start_x, start_y)
  teleportation_queue.current_map_table = { map_string = first_map_string, next_x = start_x, next_y = start_y }
end

return teleportation_queue
