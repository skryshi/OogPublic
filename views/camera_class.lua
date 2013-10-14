-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local CameraClass = display.newGroup()
	CameraClass.layer = nil
	CameraClass.viewable = {}
	CameraClass.x = 0
	CameraClass.y = 0
	CameraClass.timers = {}
	CameraClass.transitions = {}
	CameraClass.state = "ready"

	----------------------------------------------------------
	function CameraClass:init(o)
		self.layer = o.layer
		self.viewable = o.viewable
		self.x = o.x
		self.y = o.y
		self:moveTo(self.x, self.y)
		
		Runtime:addEventListener("cameraPanTo", self)
		return self
	end

	----------------------------------------------------------
	function CameraClass:cameraPanTo(event)
		print("event panTo", event.x, event.y)
		self:panTo(event.x, event.y)
	end

	----------------------------------------------------------
	function CameraClass:transformToLayerCoordinates(x, y)
		return -(x - _game.w / 2), -(y - _game.h / 2)
	end
	
	----------------------------------------------------------
	function CameraClass:clamToViewable(x, y)
		x = math.max((self.viewable.xMin + _game.w / 2), math.min(x, self.viewable.xMax - _game.w / 2))
		y = math.max((self.viewable.yMin + _game.h / 2), math.min(y, self.viewable.yMax - _game.h / 2))
		return x, y
	end

	----------------------------------------------------------
	function CameraClass:moveTo(x, y)
		self.x, self.y = self:clamToViewable(x, y)
		x, y = self:transformToLayerCoordinates(self.x, self.y)
		self.layer.x = x
		self.layer.y = y
	end

	----------------------------------------------------------
	function CameraClass:panTo(x, y)
		self.x, self.y = self:clamToViewable(x, y)
		x, y = self:transformToLayerCoordinates(self.x, self.y)
		local d = ((x - self.layer.x)^2 + (y - self.layer.y)^2)^0.5
		transition.to(self.layer, { x = x, y = y, time = d * 10 })
	end

	----------------------------------------------------------
	function CameraClass:startDrag()
		self.startX = self.x
		self.startY = self.y
	end

	----------------------------------------------------------
	function CameraClass:drag(distanceX, distanceY)
		self:moveTo(self.startX - distanceX, self.startY - distanceY)
	end

	----------------------------------------------------------
	function CameraClass:endDrag()
	end

	----------------------------------------------------------
	function CameraClass:toStr()
	end

	----------------------------------------------------------
	function CameraClass:removeSelf()
		Runtime:removeEventListener("cameraPanTo", self)
		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end
	end

	----------------------------------------------------------
--	CameraClass:init(o)

	return CameraClass
end

return class