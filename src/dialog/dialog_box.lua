local constants = require("src.util.constants")
local rpg_print = require('src.dialog.wrapped_text')

local dialog_box = {}
local Dialog_Box = {}

local box_width = constants.tile_size * 11
local box_hight = constants.tile_size * 3
local text_offset = 5
local max_character_length = 25

local draw_box = function(box_location_x, box_location_y)
  love.graphics.push()

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", box_location_x, box_location_y, box_width, box_hight)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", box_location_x, box_location_y, box_width, box_hight)
  love.graphics.reset()

  love.graphics.pop()
end

local draw_text = function(text, box_location_x, box_location_y)
  love.graphics.push()

  rpg_print(text, box_location_x, box_location_y)

  love.graphics.pop()
end

function Dialog_Box:update(dt, scaled_x, scaled_y)

end

function Dialog_Box:draw()
  draw_box(self.box_location_x, self.box_location_y)
  draw_text(self.msg, self.box_location_x + text_offset, self.box_location_y + text_offset)
end

function dialog_box.new(text, box_location_x, box_location_y)
  local self = {}
  self.msg = text
  self.box_location_x = box_location_x
  self.box_location_y = box_location_y
  self.show_box = false
  setmetatable(self, { __index = Dialog_Box })
  return self
end

return dialog_box
