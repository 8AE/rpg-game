local constants = require("src.constants")
local number_scaling = {}

number_scaling.scaled_to_real = function(scaled_number)
  return scaled_number * constants.tile_size
end

number_scaling.real_to_scaled = function(real_number)
  return math.floor(real_number / constants.tile_size)
end

return number_scaling
