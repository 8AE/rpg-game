local font = require('src.font.font')

return function(text, x, y, scale_factor)
  scale_factor = scale_factor or 1
  love.graphics.push()
  love.graphics.setFont(font)
  love.graphics.print(string.upper(text), x, y, 0, scale_factor, scale_factor)
  love.graphics.reset()
  love.graphics.pop()
end
