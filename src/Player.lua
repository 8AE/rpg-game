local constants = require("src.util.constants")
local number_scaling = require("src.util.number_scaling")
local player = {}
local Player = {}

local debug_draw_all_sprites = function(image, sprites)
  for i = 1, #sprites, 1 do
    love.graphics.draw(image, sprites[i], constants.tile_size * i, constants.tile_size)
  end
end

local function sprite_based_on_direction(player, sprites)
  local temp_sprite = sprites[1]
  if player.direction == 'up' then
    temp_sprite = sprites[11]
  elseif player.direction == 'down' then
    temp_sprite = sprites[2]
  elseif player.direction == 'left' then
    temp_sprite = sprites[5]
  elseif player.direction == 'right' then
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

local draw_debug_box = function(player)
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("line", ((player.x / constants.tile_size)) * constants.tile_size,
    ((player.y / constants.tile_size)) * constants.tile_size,
    constants.tile_size, constants.tile_size)
  love.graphics.reset()
end

function Player:draw()
  love.graphics.push()
  love.graphics.draw(self.image, sprite_based_on_direction(self, self.sprites), self.x, self.y)
  -- draw_debug_box(self)
  love.graphics.pop()
end

function Player:move(new_x, new_y)
  if not self.moving then
    self.target_x = new_x
    self.target_y = new_y
    self.moving = true
  end
end

function Player:update_position_based_on_direction()
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

function Player:update_direction_if_not_moving(new_direction)
  if not self.moving then
    self.direction = new_direction
  end
end

function Player:get_scaled_x()
  return number_scaling.real_to_scaled(self.x)
end

function Player:get_scaled_y()
  return number_scaling.real_to_scaled(self.y)
end

function Player:keypressed(key)
  if key == 'return' then
    local x = math.floor(self.x / constants.tile_size)
    local y = math.floor(self.y / constants.tile_size)
    if self.direction == 'left' then
      x = x - 1
    elseif self.direction == 'right' then
      x = x + 1
    elseif self.direction == 'up' then
      y = y - 1
    elseif self.direction == 'down' then
      y = y + 1
    end
    love.event.push('interact', x, y)
  end
end

function player.new(image_path)
  local self = {}
  self.x = 0
  self.y = 0
  self.direction = 'down'
  self.moving = false
  self.speed = 1.25
  self.target_x = 0
  self.target_y = 0
  self.inventory = {}
  self.equiped_item = nil
  self.image = love.graphics.newImage(image_path)
  self.sprites = generate_sprites(self.image)
  setmetatable(self, { __index = Player })
  return self
end

return player
