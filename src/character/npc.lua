local constants = require("src.util.constants")
local number_scaling = require("src.util.number_scaling")
local Dialog_Box = require("src.dialog.dialog_box")
local npc = {}
local Npc = {}

local function sprite_based_on_direction(npc, sprites)
  local temp_sprite = sprites[1]
  if npc.direction == 'up' then
    temp_sprite = sprites[11]
  elseif npc.direction == 'down' then
    temp_sprite = sprites[2]
  elseif npc.direction == 'left' then
    temp_sprite = sprites[5]
  elseif npc.direction == 'right' then
    temp_sprite = sprites[8]
  end
  return temp_sprite
end

local generate_sprites = function(image)
  local sprites = {}
  for i = 0, (image:getWidth() / constants.tile_size), 1 do
    for j = 0, (image:getHeight() / constants.tile_size) - 2, 1 do
      table.insert(sprites,
        love.graphics.newQuad(j * 32, i * 32, constants.tile_size, constants.tile_size, image:getWidth(),
          image:getHeight()))
    end
  end
  return sprites
end

function Npc:draw()
  love.graphics.push()
  love.graphics.draw(
    self.image,
    sprite_based_on_direction(self, self.sprites),
    number_scaling.scaled_to_real(self.x),
    number_scaling.scaled_to_real(self.y))

  self.dialog:draw()
  love.graphics.pop()
end

function Npc:move(new_x, new_y)
  if not self.moving then
    self.target_x = new_x
    self.target_y = new_y
    self.moving = true
  end
end

function Npc:update_position_based_on_direction()
  if self.moving then
    if self.direction == 'up' then
      if self.y <= self.target_y then
        self.y = self.target_y
        self.moving = false
      else
        self.y = self.y - self.speed
      end
    end

    if self.direction == 'down' then
      if self.y >= self.target_y then
        self.y = self.target_y
        self.moving = false
      else
        self.y = self.y + self.speed
      end
    end

    if self.direction == 'left' then
      if self.x <= self.target_x then
        self.x = self.target_x
        self.moving = false
      else
        self.x = self.x - self.speed
      end
    end

    if self.direction == 'right' then
      if self.x >= self.target_x then
        self.x = self.target_x
        self.moving = false
      else
        self.x = self.x + self.speed
      end
    end
  end
end

function Npc:update_direction_if_not_moving(new_direction)
  if not self.moving then
    self.direction = new_direction
  end
end

function Npc:update(dt)

end

function Npc:keypressed(key)
  self.dialog:keypressed(key)
end

function Npc:get_scaled_x()
  return number_scaling.real_to_scaled(self.x)
end

function Npc:get_scaled_y()
  return number_scaling.real_to_scaled(self.y)
end

function Npc:can_move(target_x, target_y, player_direction)
  return not ((self.x == target_x and self.y == target_y) or
    (player_direction == 'right' and self.x == target_x + 1 and self.y == target_y) or
    (player_direction == 'down' and self.x == target_y + 1) and self.x == target_x)
end

function Npc:handle_interact(x, y)
  print(self.x)
  if self.x == x and self.y == y then
    print("L")
  end
end

-- function love.handlers.interact(x, y)
--   npc:handle_interact(x, y)
-- end

function npc.new(image_path, x, y, direction, can_be_moved, can_be_damaged, messages)
  local self = {}
  self.x = x
  self.y = y
  self.direction = direction
  self.can_be_moved = can_be_moved
  self.can_be_damaged = can_be_damaged
  self.dialog = Dialog_Box.new(
    messages,
    love.graphics.getWidth() / 2,
    love.graphics.getHeight() / 2)
  self.moving = false
  self.speed = 1.25
  self.target_x = 0
  self.target_y = 0
  self.equiped_item = nil
  self.image = love.graphics.newImage('data/image/' .. image_path)
  self.sprites = generate_sprites(self.image)
  setmetatable(self, { __index = Npc })

  love.handlers.interact = function(x, y)
    if self.x == x and self.y == y then
      if not self.dialog:is_box_visible() then
        self.dialog:set_box_visability_to(true)
      end
    end
  end

  return self
end

return npc
