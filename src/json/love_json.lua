local json = require("lib.json.json")
local love_json = {}

love_json.decode_json = function(filename)
  -- Check if the file exists
  if love.filesystem.getInfo(filename) then
    -- Read the contents of the file
    local fileContents, _ = love.filesystem.read(filename)

    -- Parse the JSON data into a Lua table
    local jsonData = json.decode(fileContents)

    -- Return the resulting table
    return jsonData
  else
    -- File does not exist, handle accordingly
    print("File not found: " .. filename)
    return nil
  end
end

return love_json
