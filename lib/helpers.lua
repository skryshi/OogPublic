-- Copyright 2013 Arman Darini

helpers = {
	----------------------------------------------------------
	convertExpToLevel = function(exp)
		for i = 1, #_game.exp do
			if exp < _game.exp[i] then return i - 1 end
		end
	end,
	
	----------------------------------------------------------
	getPlayerLevel = function()
		return helpers.convertExpToLevel(_player.exp)
	end,

	----------------------------------------------------------
	expSinceLevel = function()
		return _player.exp - _game.exp[helpers.getPlayerLevel()]
	end,

	----------------------------------------------------------
	percentLevelComplete = function()
		return helpers.expSinceLevel() / (_game.exp[helpers.getPlayerLevel() + 1] - _game.exp[helpers.getPlayerLevel()])
	end,
	
	----------------------------------------------------------
	computeStars = function(score, level)
		i = 0
		while i < #_game.levels[level].stars and score >= _game.levels[level].stars[i + 1] do
			i = i + 1
		end
		return i
	end,
	
	----------------------------------------------------------
	isLevelUnlocked = function(level)
		if 1 == level or _player.levels[level].highScore > _game.levels[level].stars[1] or _player.levels[level - 1].highScore > _game.levels[level - 1].stars[1] then
			return true
		else
			return false
		end
	end,

	----------------------------------------------------------
	setFillColor = function(object, o)
		if "table" == type(o) then
			object:setFillColor(o[1], o[2], o[3])
		else
			if 1 == o then
				object:setFillColor(255, 0, 0)
			elseif 2 == o then
				object:setFillColor(0, 255, 0)
			elseif 3 == o then
				object:setFillColor(0, 0, 255)
			elseif 4 == o then
				object:setFillColor(255, 255, 0)
			elseif 5 == o then
				object:setFillColor(0, 255, 255)
			elseif 6 == o then
				object:setFillColor(255, 0, 255)
			elseif 7 == o then
				object:setFillColor(128, 0, 0)
			elseif 8 == o then
				object:setFillColor(0, 128, 0)
			elseif 9 == o then
				object:setFillColor(0, 0, 128)
			elseif 10 == o then
				object:setFillColor(128, 128, 128)
			else
				object:setFillColor(255, 255, 255)
			end
		end
	end,
}

return helpers