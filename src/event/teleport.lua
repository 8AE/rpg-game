local constants = require("src.util.constants")
local number_scale = require("src.util.number_scaling")
local teleport = {}
local Teleport = {}

function Teleport:draw()
  love.graphics.push()
  love.graphics.setColor(0, 0, 255)
  love.graphics.rectangle("line", number_scale.scaled_to_real(self.starting_x),
    number_scale.scaled_to_real(self.starting_y),
    constants.tile_size, constants.tile_size)
  love.graphics.reset()
  love.graphics.pop()
end

function Teleport:update(dt, scaled_x, scaled_y)
  if scaled_x == self.starting_x and scaled_y == self.starting_y then
    self.teleportation_queue.add_to_map_transition({
      map_string = self.next_map_substring,
      next_x = self.next_x,
      next_y = self.next_y
    })
  end
end

function Teleport:can_move()
  return true
end

function teleport.new(teleportation_queue, starting_x, starting_y, next_map_substring, next_x, next_y)
  local self = {}
  self.teleportation_queue = teleportation_queue
  self.starting_x = starting_x
  self.starting_y = starting_y
  self.next_map_substring = next_map_substring
  self.next_x = next_x
  self.next_y = next_y
  setmetatable(self, { __index = Teleport })
  return self
end

return teleport
