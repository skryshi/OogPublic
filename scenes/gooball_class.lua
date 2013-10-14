-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local GooballClass = display.newGroup()
	GooballClass.view = nil
	GooballClass.sheetInfo = require("images.scenes.play_level.oog")
	GooballClass.sheet = graphics.newImageSheet("images/scenes/play_level/oog.png", GooballClass.sheetInfo:getSheet())
	GooballClass.animationSequences =
	{
		{
			{ name = "default", frames = { 4 }, time = 2000 },
			{ name = "blinking", frames = { 3, 6, 8 }, time = 1000, loopCount = 1 },
			{ name = "suspicious", frames = { 4, 5 }, time = 2000, loopCount = 1 },
			{ name = "looking", frames = { 1, 2 }, time = 2000, loopCount = 1 },
			{ name = "eyepop", frames = { 2, 3, 1 }, time = 2000, loopCount = 1 },
			{ name = "remove", frames = { 27, 28, 29, 29 }, time = 250, loopCount = 1 },
		},
		{
			{ name = "default", frames = { 16 }, time = 2000 },
			{ name = "love", frames = { 13, 15, 14, 15, 14, 15 }, time = 4000, loopCount = 1 },
			{ name = "looking", frames = { 10, 11 }, time = 2000, loopCount = 2 },
			{ name = "looking2", frames = { 9, 10, 11, 10, 11 }, time = 2000, loopCount = 1 },
			{ name = "blinking", frames = { 9, 12, 9, 12, 9 }, time = 2000, loopCount = 1 },
			{ name = "eyepop", frames = { 9, 13 }, time = 2000, loopCount = 1 },
			{ name = "remove", frames = { 27, 28, 29, 29 }, time = 250, loopCount = 1 },
		},
		{
			{ name = "default", frames = { 25 }, time = 2000 },
			{ name = "love", frames = { 24, 23, 22, 23, 22 }, time = 4000, loopCount = 1 },
			{ name = "looking", frames = { 18, 19 }, time = 2000, loopCount = 2 },
			{ name = "eyeroll", frames = { 18, 20, 19 }, time = 2000, loopCount = 1 },
			{ name = "blinking", frames = { 18, 21, 18, 21, 18 }, time = 1000, loopCount = 1 },
			{ name = "eyepop", frames = { 18, 25, 19 }, time = 2000, loopCount = 1 },
			{ name = "remove", frames = { 27, 28, 29, 29 }, time = 250, loopCount = 1 },
		},
	}
	GooballClass.state = nil
	GooballClass.name = nil
	GooballClass.timers = {}
	GooballClass.transitions = {}

	----------------------------------------------------------
	function GooballClass:init(o)
		self.state = o.state
		self.category = o.category
		self.name = self.state
		self.view = display.newSprite(self.sheet, self.animationSequences[self.category])
		self:insert(self.view)
		o.layer:insert(self)
		if "radical" == self.state then
			self.view:setSequence("shut")
		else
			self.view:setSequence("default")
		end
		self.view:play()
		self.view:scale(1, 1)
		self.view:setReferencePoint(display.CenterReferencePoint)
		self:setReferencePoint(display.CenterReferencePoint)

		self.timers[#self.timers + 1] = timer.performWithDelay(1000, function() self:updateAnimation() end, 0)

		return self
	end

	----------------------------------------------------------
	function GooballClass:updateAnimation(event)
		if true == self.view.isPlaying and "default" ~= self.view.sequence then
			return
		end
		if 1 == math.random(1, 3) then
			self.view:setSequence(self.animationSequences[self.category][math.random(1, #self.animationSequences[self.category] - 1)].name)
		else
			self.view:setSequence("default")
		end
		self.view:play()
	end

	----------------------------------------------------------
	function GooballClass:selectedForRemovalAnimation()
		if nil ~= self.transitions.selected then
			transition.cancel(self.transitions.selected)
		end
		self.transitions.selected = transition.to(self.view, { xScale = 2, yScale = 2, time = 3000 })
	end

	----------------------------------------------------------
	function GooballClass:deselectedForRemovalAnimation()
		if nil ~= self.transitions.selected then
			transition.cancel(self.transitions.selected)
		end
		self.transitions.selected = transition.to(self.view, { xScale = 1, yScale = 1, time = 1000 })
	end

	----------------------------------------------------------
	function GooballClass:toStr()
	end

	----------------------------------------------------------
	function GooballClass:removeSelfWithAnimation()
		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end	

		self.view:setSequence("remove")
		self.view:play()

		self.view:addEventListener("sprite", function(event)
		  if (event.phase == "ended") then
				timer.performWithDelay(10, function() self.view:removeSelf() end, 1)
			end
		end)
	end

	----------------------------------------------------------
	function GooballClass:removeSelf()
		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end	
		display.remove(self.view)
	end

	----------------------------------------------------------
	GooballClass:init(o)

	return GooballClass
end

return class
