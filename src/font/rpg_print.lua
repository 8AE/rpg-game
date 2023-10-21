local font = require('src.font.font')

return function(text, x, y)
  love.graphics.push()
  love.graphics.setFont(font)
  love.graphics.print(string.upper(text), x, y)
  love.graphics.reset()
  love.graphics.pop()
end
