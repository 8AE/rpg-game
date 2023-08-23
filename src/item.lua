local tile_size = 32
local item = {}
local Item = {}

function Item:draw(x, y)
  love.graphics.draw(self.image_sheet, self.icon_quad, x,
    y)
end

function item.new(image_sheet, icon_quad, name, description)
  local self = {}
  self.image_sheet = image_sheet
  self.icon_quad = icon_quad
  self.name = name
  self.description = description
  setmetatable(self, { __index = Item })
  return self
end

return item
