local tile_size = 32
return function(image, row, col)
  return love.graphics.newQuad(row * tile_size, col * tile_size, tile_size, tile_size, image:getWidth(),
    image:getHeight())
end
