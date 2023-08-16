local tile_size = 32

local function debug_draw_all_sprites(image, sprites)
  for i = 1, #sprites, 1 do
    love.graphics.draw(image, sprites[i], tile_size * i, tile_size)
  end
end

local function sprite_based_on_direction(player, sprites)
  temp_sprite = sprites[1]
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

local function generate_sprites(image)
  local sprites = {}
  for i = 0, (image:getWidth() / tile_size), 1 do
    for j = 0, (image:getHeight() / tile_size) - 2, 1 do
      table.insert(sprites,
        love.graphics.newQuad(j * 32, i * 32, tile_size, tile_size, image:getWidth(), image:getHeight()))
    end
  end
  return sprites
end

local function draw_debug_box(player)
  love.graphics.setColor(255, 0, 0)
  love.graphics.rectangle("line", ((player.x / tile_size)) * tile_size, ((player.y / tile_size)) * tile_size,
    tile_size, tile_size)
  love.graphics.reset()
end

return function(image_path, starting_x, starting_y)
  local player = {}
  player.x = starting_x * tile_size
  player.y = starting_y * tile_size
  local image = love.graphics.newImage(image_path)
  local sprites = generate_sprites(image)
  player.direction = 'down'
  player.moving = false
  player.speed = 1.25
  player.target_x = 0
  player.target_y = 0

  function player:draw()
    love.graphics.push()
    love.graphics.scale(2, 2)
    love.graphics.draw(image, sprite_based_on_direction(player, sprites), player.x, player.y)
    draw_debug_box(player)
    love.graphics.pop()
  end

  function player:move(new_x, new_y)
    if not self.moving then
      self.target_x = new_x
      self.target_y = new_y
      self.moving = true
    end
  end

  function player:update_position_based_on_direction()
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

  function player:update_direction_if_not_moving(new_direction)
    if not self.moving then
      self.direction = new_direction
    end
  end

  return player
end
