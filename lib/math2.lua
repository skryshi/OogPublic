-- Copyright 2013 Arman Darini

local math = require "math"

math.sign = function(value)
	if value > 0 then return 1; elseif value < 0 then return -1; else return 0; end
end

math.round = function(x)
	return math.floor(x + 0.5)
end

return math