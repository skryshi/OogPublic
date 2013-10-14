-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local ExitClass = display.newGroup()
	ExitClass.view = nil
	ExitClass.sheetInfo = require("images.scenes.play_level.01.sheet")
	ExitClass.sheet = graphics.newImageSheet("images/scenes/play_level/01/sheet.png", ExitClass.sheetInfo:getSheet())		
	ExitClass.animationSequences =
	{
		{ name = "default", start = 13, count = 8, time = 1500 },
		{ name = "active", start = 6, count = 7, time = 1500 },
	}
	ExitClass.state = nil
	ExitClass.timers = {}
	ExitClass.transitions = {}
	ExitClass.physicsProperties = {  isSensor = true, density = 10, friction = 0.1, bounce = 0, radius = 12, filter = { categoryBits = 8, maskBits = 3, groupIndex = 0 } }

	----------------------------------------------------------
	function ExitClass:init(o)
		self.state = o.state or "default"
		self.view = display.newSprite(self.sheet, self.animationSequences)
		self:insert(self.view)
		o.layer:insert(self)
		self:_animateToState()
		self.view:setReferencePoint(display.CenterReferencePoint)
		self:setReferencePoint(display.CenterReferencePoint)
		physics.addBody(self, "static", physicsProperties)

		return self
	end

	----------------------------------------------------------
	function ExitClass:setState(state)
		self.state = state
		self:_animateToState()
	end
	
	----------------------------------------------------------
	function ExitClass:_animateToState()
		self.view:setSequence(self.state)
		self.view:play()
	end

	----------------------------------------------------------
	function ExitClass:toStr()
	end

	----------------------------------------------------------
	function ExitClass:removeSelf()
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
	ExitClass:init(o)

	return ExitClass
end

return class
