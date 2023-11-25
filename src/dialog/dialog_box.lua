local constants = require("src.util.constants")
local text_wrap_print = require('src.dialog.wrapped_text')

local dialog_box = {}
local Dialog_Box = {}

local box_width = constants.tile_size * 12
local box_hight = constants.tile_size * 3
local text_offset = 5

local draw_box = function(box_location_x, box_location_y)
  love.graphics.push()

  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", box_location_x, box_location_y, box_width, box_hight)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("line", box_location_x, box_location_y, box_width, box_hight)
  love.graphics.reset()

  love.graphics.pop()
end

local draw_text = function(text_table, table_pos, box_location_x, box_location_y)
  love.graphics.push()

  text_wrap_print(text_table[table_pos], box_location_x, box_location_y)

  love.graphics.pop()
end

function Dialog_Box:update(dt, scaled_x, scaled_y)

end

function Dialog_Box:draw()
  if self.show_box == true then
    draw_box(self.box_location_x, self.box_location_y)
    draw_text(self.text_table, self.table_pos, self.box_location_x + text_offset, self.box_location_y + text_offset)
  end
end

function Dialog_Box:keypressed(key)
  if key == 'return' and self.show_box == true then
    if self.text_table[self.table_pos + 1] == nil then
      self.table_pos = 1
      self.show_box = false
    else
      self.table_pos = self.table_pos + 1
    end
  end
end

function Dialog_Box:is_box_visible()
  return self.show_box
end

function Dialog_Box:set_box_visability_to(state)
  self.show_box = state
end

function dialog_box.new(text_table, box_location_x, box_location_y)
  local self = {}
  self.text_table = text_table
  self.box_location_x = box_location_x
  self.box_location_y = box_location_y
  self.table_pos = 1
  self.show_box = false
  setmetatable(self, { __index = Dialog_Box })
  return self
end

return dialog_box
