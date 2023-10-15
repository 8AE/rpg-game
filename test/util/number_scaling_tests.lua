local cute = require("lib.cute.cute")
local number_scaling = require("src.util.number_scaling")

notion("scaled to real", function()
    check(number_scaling.scaled_to_real(5)).is(5 * 32)
end)

notion("real to scaled", function()
    check(number_scaling.real_to_scaled(5 * 32)).is(5)
end)
