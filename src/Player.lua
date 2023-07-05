local tile_size = 32

local function draw_player_based_on_current_direction()

end

local function generate_sprites(image)
  local sprites = {}
  for i = 0, (image:getWidth() / tile_size) - 1, 1 do
    for j = 0, (image:getHeight() / tile_size) - 1, 1 do
      table.insert(sprites,
        love.graphics.newQuad(j * 32, i * 32, tile_size, tile_size, image:getWidth(), image:getHeight()))
    end
  end
  return sprites
end

return function(image_path, starting_x, starting_y)
  local player = {}
  player.x = starting_x
  player.y = starting_y
  local image = love.graphics.newImage(image_path)
  local sprites = generate_sprites(image)
  local direction


  function player:draw()
    love.graphics.push()
    love.graphics.scale(2, 2)
    love.graphics.draw(image, sprites[1], player.x, player.y)
    -- love.graphics.draw(image, sprites[2], 1 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[3], 2 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[4], 3 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[5], 4 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[6], 5 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[7], 6 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[8], 7 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[9], 8 * tile_size, 0 * tile_size)
    -- love.graphics.draw(image, sprites[10], 9 * tile_size, 0 * tile_size)
    love.graphics.pop()
  end

  return player
end
