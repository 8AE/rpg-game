local cute = require("lib.cute.cute")

notion("Can compare numbers, strings, etc", function()
  check(1).is(1)
  check("hello").is("hello")
end)
