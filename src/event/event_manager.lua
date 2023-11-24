local json = require("src.json.love_json")
local Teleport = require("src.event.teleport")
local Npc = require('src.character.npc')

local event_manager = {}
local Event_Manager = {}

function Event_Manager:update(dt, scaled_x, scaled_y)
  for _, events in ipairs(self.parsed_events) do
    events:update(dt, scaled_x, scaled_y)
  end
end

function Event_Manager:draw()
  for _, events in ipairs(self.parsed_events) do
    events:draw()
  end
end

local parse_event = function(queue, json_data)
  local events = {}
  for event_type, event_data in pairs(json_data) do
    if event_type == 'move' then
      for _, data in ipairs(event_data) do
        table.insert(events, Teleport.new(queue, data.x, data.y, data.next_map, data.next_x, data.next_y))
      end
    elseif event_type == 'characters' then
      for _, data in ipairs(event_data) do
        table.insert(events,
          Npc.new(
            data.image,
            data.x,
            data.y,
            data.default_direction_facing,
            data.can_they_move,
            data.can_they_be_damaged,
            data.messages))
      end
    end
  end

  return events
end

function event_manager.new(teleportation_queue, event_path)
  local self = {}
  self.teleportation_queue = teleportation_queue
  self.parsed_events = parse_event(teleportation_queue, json.decode_json(event_path))
  setmetatable(self, { __index = Event_Manager })
  return self
end

return event_manager
