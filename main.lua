local cute = require("lib.cute.cute")
local app = require("src.app")

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
  local lldebugger = require "lldebugger"
  lldebugger.start()
  local run = love.run
  function love.run(...)
    local f = lldebugger.call(run, false, ...)
    return function(...) return lldebugger.call(f, false, ...) end
  end
end

function love.load(args)
  cute.go(args)
  app.load(args)
end

function love.draw()
  app.draw()

  cute.draw(love.graphics)
end

function love.update(dt)
  app.update(dt)
end

love.keypressed = function(key)
  cute.keypressed(key)
  app.keypressed(key)
end
