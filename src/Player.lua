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
  player.speed = 1

  function player:draw()
    love.graphics.push()
    love.graphics.scale(2, 2)
    love.graphics.draw(image, sprite_based_on_direction(player, sprites), player.x, player.y)
    draw_debug_box(player)
    love.graphics.pop()
  end

  return player
end
