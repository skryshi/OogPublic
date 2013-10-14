-- Copyright 2013 Arman Darini

local GooballClass = require("scenes.gooball_class")

local class = {}
class.new = function(o)
	local LatticeClass = display.newGroup()
	LatticeClass.sheetInfo = require("images.scenes.play_level.oog")
	LatticeClass.sheet = graphics.newImageSheet("images/scenes/play_level/oog.png", LatticeClass.sheetInfo:getSheet())		
	LatticeClass.layer = nil
	LatticeClass.camera = nil
	LatticeClass.timers = {}
	LatticeClass.transitions = {}
	LatticeClass.vertices = {}
	LatticeClass.edges = {}
	LatticeClass.edgeHints = { edges = {} }
	LatticeClass.radicals = {}	
	LatticeClass.radicalSpeed = 0.01
	LatticeClass.minJointLength = 70
	LatticeClass.maxJointLength = 150
	LatticeClass.radicalHeld = nil
	LatticeClass.minDragDistanceToConvertRadical = 20
	LatticeClass.minDragDistanceToRemoveVertex = 20
	LatticeClass.exitVertex = nil

	LatticeClass.gooballRadius = 20
	LatticeClass.vertexProperties = { bodyType = "dynamic", density = 10, friction = 0.1, bounce = 0.3, radius = 12, filter = { categoryBits = 2, maskBits = 3, groupIndex = 0 } }
	LatticeClass.radicalProperties = { bodyType = "dynamic", density = 1, friction = 0, bounce = 0.3, filter = { categoryBits = 4, maskBits = 0, groupIndex = 0 } }

	----------------------------------------------------------
	function LatticeClass:init(o)
		self.layer = o.layer or display.newGroup()
		self.camera = o.camera or nil
		
		Runtime:addEventListener("enterFrame", self)
		return self
	end

	----------------------------------------------------------
	function LatticeClass:getLayer()
		return self.layer
	end

	----------------------------------------------------------
	function LatticeClass:addStructure(o)
		_utils.printTable(o)
		for i = 1, #o.vertices do
			self:addVertex(o.vertices[i][1], o.vertices[i][2], o.vertices[i][3])
		end
		for i = 1, #o.edges do
			self:addEdge(self.vertices[o.edges[i][1]], self.vertices[o.edges[i][2]])
		end
	end
	
	----------------------------------------------------------
	function LatticeClass:addRadicals(count)
		for i = 1, count do
--		self.radicals[#self.radicals + 1] = display.newCircle(self.layers, 0, 0, self.gooballRadius)
			self.radicals[#self.radicals + 1] = GooballClass.new({ layer = self.layer, state = "radical", category = math.random(1, 3) })

			local start = math.random(1, #self.edges)
			self.radicals[#self.radicals].edge = self.edges[start]
			self.radicals[#self.radicals].distance = 0.5 * math.random(80, 120) / 100
			self.radicals[#self.radicals].speed = self.radicalSpeed * math.random(80, 120) / 100
--			_helpers.setFillColor(self.radicals[#self.radicals].view, self.radicals[#self.radicals].category)
			local vertex1 = self.radicals[#self.radicals].edge.vertices[1]
			local vertex2 = self.radicals[#self.radicals].edge.vertices[2]
			self.radicals[#self.radicals].x = (vertex2.x - vertex1.x) * self.radicals[#self.radicals].distance
			self.radicals[#self.radicals].y = (vertex2.y - vertex1.y) * self.radicals[#self.radicals].distance

			self.radicals[#self.radicals]:addEventListener("touch", function(event) return self:radicalListener(event) end)
		end
	end
		
	----------------------------------------------------------
	function LatticeClass:removeRadical(radical)
		print("removeRadical")
		-- remove radical
		for i = #self.radicals, 1, -1 do
			if self.radicals[i] == radical then
				print("removing radical")
				table.remove(self.radicals, i)
			end
		end
		-- remove view
		radical:removeSelf()
	end

	----------------------------------------------------------
	function LatticeClass:addEdge(vertex1, vertex2)
		self.edges[#self.edges + 1] = {}
		self.edges[#self.edges].vertices = { vertex1, vertex2 }
		self.edges[#self.edges].joint = physics.newJoint("distance", vertex1, vertex2, vertex1.x, vertex1.y, vertex2.x, vertex2.y)
		self.edges[#self.edges].joint.length = math.min(self.maxJointLength, math.max(self.minJointLength, _utils.distance(vertex1, vertex2)))
		self.edges[#self.edges].joint.dampingRatio = 10
		self.edges[#self.edges].joint.frequency = 3

		local frame = self.sheetInfo:getFrameIndex("string"..vertex2.category)
		self.edges[#self.edges].view = display.newImageRect(self.layer, self.sheet, frame, self.sheetInfo:getSheet().frames[frame].width, self.sheetInfo:getSheet().frames[frame].height)
		self.edges[#self.edges].view:setReferencePoint(display.TopCenterReferencePoint)		
		self.edges[#self.edges].view:toBack()
		vertex1.edges[#vertex1.edges + 1] = self.edges[#self.edges]
		vertex2.edges[#vertex2.edges + 1] = self.edges[#self.edges]
	end

	----------------------------------------------------------
	function LatticeClass:removeEdge(edge)
		print("removeEdge")
		_utils.printTable(edge)
		print(#edge.vertices)
		-- remove edge from vertices
		for i = 1, #edge.vertices do
			for j = 1, #edge.vertices[i].edges do
				if edge == edge.vertices[i].edges[j] then
					print("remove edge from vertex", i, j)
					table.remove(edge.vertices[i].edges, j)
				end
			end
		end
		-- remove edge from edges
		for i = 1, #self.edges do
			if self.edges[i] == edge then
				table.remove(self.edges, i)
			end
		end
		-- move radicals
		for i = 1, #self.radicals do
			if self.radicals[i].edge == edge then
				local start = math.random(1, #self.edges)
				self.radicals[i].edge = self.edges[start]
			end
		end

		-- remove physical joint and view
		edge.joint:removeSelf()
		edge.view:removeSelf()
	end

	----------------------------------------------------------
	function LatticeClass:addVertex(x, y, category)
--		self.vertices[#self.vertices + 1] = display.newCircle(self.layer, x, y, self.gooballRadius)
		self.vertices[#self.vertices + 1] = GooballClass.new({ layer = self.layer, state = "vertex", category = category })
		self.vertices[#self.vertices].x = x
		self.vertices[#self.vertices].y = y

		physics.addBody(self.vertices[#self.vertices], self.vertexProperties)
--		self.vertices[#self.vertices].isFixedRotation = true
		self.vertices[#self.vertices].edges = {}

		self.vertices[#self.vertices]:addEventListener("touch", function(event) return self:removeVertexListener(event) end)
	end

	----------------------------------------------------------
	function LatticeClass:removeVertex(vertex)
		print("removeVertex")
		if #self.vertices <= 2 then return end
		print("#vertices = ", #self.vertices)
		for i = 1, #self.vertices do
			print("vertex=", vertex, "vertices["..i.."]=", self.vertices[i])
		end
		print("#vertex.edges=", #vertex.edges)
		local edgeCopy = _utils.copyTable(vertex.edges)
		-- remove edges
		for i = 1, #edgeCopy do
			self:removeEdge(edgeCopy[i])
		end
		-- remove vertex
		for i = 1, #self.vertices do
			if self.vertices[i] == vertex then
				table.remove(self.vertices, i)
			end
		end
		for i = 1, #self.vertices do
			print("vertex=", vertex, "vertices["..i.."]=", self.vertices[i])
		end
		-- remove physical vertex and view
		physics.removeBody(vertex)
		vertex:removeSelfWithAnimation()
	end

	----------------------------------------------------------
	function LatticeClass:getNearestVertices(x, y, count)
		table.sort(self.vertices, function(vertex1, vertex2)
			return ((x - vertex1.x)^2 + (y - vertex1.y)^2) < ((x - vertex2.x)^2 + (y - vertex2.y)^2)
		end)
		local result = {}
		for i = 1, count do
			result[#result + 1] = self.vertices[i]
		end
		return result
	end
	
	----------------------------------------------------------
	function LatticeClass:updateEdges()
		for i = 1, #self.edges do
			local ax, ay = self.edges[i].joint:getAnchorA()
			local bx, by = self.edges[i].joint:getAnchorB()
			local d = ((ax - bx)^2 + (ay - by)^2)^0.5
			self.edges[i].view.x = ax
			self.edges[i].view.y = ay
			if 1 == i then
	--			print(i, ax, ay, bx, by, math.abs(ax - bx), math.abs(ay - by))
			end
			local angle = math.sign(ax - bx) * math.deg(math.acos((by - ay) / d))
			self.edges[i].view.rotation = angle
			self.edges[i].view.yScale = d / self.edges[i].view.height
		end
	end

	----------------------------------------------------------
	function LatticeClass:updateEdgeHints()
		if nil ~= self.edgeHints.vertices then
			-- remove old hints
			for i = 1, #self.edgeHints.edges do
				self.edgeHints.edges[i]:removeSelf()
			end
			self.edgeHints.edges = {}
			-- draw joint hints
			for i = 1, #self.edgeHints.vertices do
--				self.edgeHints.hints[i] = display.newLine(layers.content, self.edgeHints.x, self.edgeHints.y, self.edgeHints.vertices[i].x, self.edgeHints.vertices[i].y)
				local frame = self.sheetInfo:getFrameIndex("string1")
				local frame = self.sheetInfo:getFrameIndex("string"..self.edgeHints.targetVertex.category)
				self.edgeHints.edges[i] = display.newImageRect(self.layer, self.sheet, frame, self.sheetInfo:getSheet().frames[frame].width, self.sheetInfo:getSheet().frames[frame].height)
				self.edgeHints.edges[i]:setReferencePoint(display.TopCenterReferencePoint)		
				self.edgeHints.edges[i].alpha = 0.3

				local ax, ay = self.edgeHints.x, self.edgeHints.y
				local bx, by = self.edgeHints.vertices[i].x, self.edgeHints.vertices[i].y
				local d = ((ax - bx)^2 + (ay - by)^2)^0.5
				self.edgeHints.edges[i].x = ax
				self.edgeHints.edges[i].y = ay
				local angle = math.sign(ax - bx) * math.deg(math.acos((by - ay) / d))
				self.edgeHints.edges[i].rotation = angle
				self.edgeHints.edges[i].yScale = d / self.edgeHints.edges[i].height
				self.edgeHints.edges[i]:toBack()
			end
		end
	end

	----------------------------------------------------------
	function LatticeClass:updateRadicals()
		local toRemove = {}
		for i = 1, #self.radicals do
			if nil == self.radicals[i].fingerJoint then
				-- if radical is next to active exit, it escapes
--				print("LatticeClass:updateRadicals self.exitVertex=", self.exitVertex)
				if nil ~= self.exitVertex and ((self.exitVertex.x - self.radicals[i].x)^2 + (self.exitVertex.y - self.radicals[i].y)^2)^.5 < 5 then
					print("LatticeClass:updateRadicals radical saved")
					toRemove[#toRemove + 1] = self.radicals[i]
					audio.play(_sounds.rescue_radical, { channel = 1 })
					Runtime:dispatchEvent({ name = "oogCollected" })
				else
					-- move radical
					local ax, ay = self.radicals[i].edge.joint:getAnchorA()
					local bx, by = self.radicals[i].edge.joint:getAnchorB()
					self.radicals[i].x = ax + (bx - ax) * self.radicals[i].distance
					self.radicals[i].y = ay + (by - ay) * self.radicals[i].distance
					self.radicals[i].distance = self.radicals[i].distance + self.radicals[i].speed
					if 0 >= self.radicals[i].distance or self.radicals[i].distance >= 1 then
						local vertice = (0 >= self.radicals[i].distance and 1 or 2)
						self.radicals[i].edge = self.radicals[i].edge.vertices[vertice].edges[math.random(1, #self.radicals[i].edge.vertices[vertice].edges)]
						-- is the ball at anchorA or anchorB
						local ax, ay = self.radicals[i].edge.joint:getAnchorA()
						local bx, by = self.radicals[i].edge.joint:getAnchorB()
						local aDistance = (ax - self.radicals[i].x)^2 + (ay - self.radicals[i].y)^2
						local bDistance = (bx - self.radicals[i].x)^2 + (by - self.radicals[i].y)^2
						if aDistance < bDistance then
							self.radicals[i].distance = 0
							self.radicals[i].speed = math.abs(self.radicals[i].speed)
						else
							self.radicals[i].distance = 1
							self.radicals[i].speed = -math.abs(self.radicals[i].speed)
						end
					end
				end
			end
		end
		for i = 1, #toRemove do
			self:removeRadical(toRemove[i])
		end
	end

	----------------------------------------------------------
	function LatticeClass:enterFrame()
		self:updateEdges()
		self:updateEdgeHints()
		self:updateRadicals()
	end

	----------------------------------------------------------
	function LatticeClass:removeVertexListener(event)
		print("LatticeClass:removeVertexListener", event.phase)
		if "began" == event.phase then
			event.target.touchTime = event.time
			display.getCurrentStage():setFocus(event.target)
			event.target:selectedForRemovalAnimation()
			self.timers.removeVertex = timer.performWithDelay(3000, function()
				audio.play(_sounds.remove_vertex, { channel = 1 })
				self:removeVertex(event.target)
				self.timers.removeVertex = nil
			end, 1)
		elseif ("ended" == event.phase or "cancelled" == event.phase) and nil ~= self.timers.removeVertex and nil ~= event.target then
			timer.cancel(self.timers.removeVertex)
			self.timers.removeVertex = nil
			event.target:deselectedForRemovalAnimation()
--			if ((event.x - event.xStart)^2 + (event.y - event.yStart)^2)^0.5 > self.minDragDistanceToRemoveVertex then
--			if event.time - event.target.touchTime > 3000 then
--				self:removeVertex(event.target)
--			else
--				event.target:deselectedForRemovalAnimation()
--			end
			display.getCurrentStage():setFocus(nil)
			_utils.printTable(event)
		end
		return true
	end

	----------------------------------------------------------
	function LatticeClass:radicalListener(event)
		local layerX, layerY = event.target.parent.parent.x, event.target.parent.parent.y
		if "began" == event.phase then
			display.getCurrentStage():setFocus(event.target)
			physics.addBody(event.target, self.radicalProperties )
--			event.target.isFixedRotation = true
			event.target.fingerJoint = physics.newJoint("touch", event.target, event.target.x, event.target.y)

			self.edgeHints.targetVertex = event.target
			self.edgeHints.x = event.x - layerX
			self.edgeHints.y = event.y - layerY
			self.edgeHints.vertices = self:getNearestVertices(event.x - layerX, event.y - layerY, event.target.category)
			audio.play(_sounds.catch_radical, { channel = 1 })
			return true
		elseif "moved" == event.phase then
			if nil ~= event.target.fingerJoint then
				event.target.fingerJoint:setTarget(event.x - layerX, event.y - layerY)
			end
			
			self.edgeHints.x = event.x - layerX
			self.edgeHints.y = event.y - layerY
			self.edgeHints.vertices = self:getNearestVertices(event.x - layerX, event.y - layerY, event.target.category)
--			Runtime:dispatchEvent({ name = "cameraPanTo", x = event.x, y = event.y })
		elseif "ended" == event.phase then
			-- when clicking very fast, began and ended events can intermix. if they had, fingerJoint might be nil
			if nil ~= event.target.fingerJoint then
				event.target.fingerJoint:removeSelf()
			end
			event.target.fingerJoint = nil
			physics.removeBody(event.target)
			display.getCurrentStage():setFocus(nil)

			-- remove joint hints
			for i = 1, #self.edgeHints.edges do
				self.edgeHints.edges[i]:removeSelf()
			end
			self.edgeHints = { edges = {} }

			if ((event.x - event.xStart)^2 + (event.y - event.yStart)^2)^0.5 > self.minDragDistanceToConvertRadical then
				-- find closest vertices
				local closestVertices = self:getNearestVertices(event.x - layerX, event.y - layerY, event.target.category)
				-- add vertex
				self:addVertex(event.x - layerX, event.y - layerY, event.target.category)
				-- add edge
				for i = 1, math.min(event.target.category, #self.vertices - 1) do
					self:addEdge(closestVertices[i], self.vertices[#self.vertices])
				end
				-- play sound
				audio.play(_sounds.place_radical, { channel = 1 })
				-- remove radical
				self:removeRadical(event.target)
			end
		elseif "cancelled" == event.phase then
			-- when clicking very fast, began and ended events can intermix. if they had, fingerJoint might be nil
			if nil ~= event.target.fingerJoint then
				event.target.fingerJoint:removeSelf()
			end
			event.target.fingerJoint = nil
			physics.removeBody(event.target)
			display.getCurrentStage():setFocus(nil)

			-- remove edge hints
			for i = 1, #self.edgeHints.edges do
				self.edgeHints.edges[i]:removeSelf()
			end
			self.edgeHints = { edges = {} }
		end
		return true
	end
	
	----------------------------------------------------------
	function LatticeClass:attachToExit(vertex)
		self.exitVertex = vertex
	end

	----------------------------------------------------------
	function LatticeClass:toStr()
	end

	----------------------------------------------------------
	function LatticeClass:removeSelf()
		Runtime:removeEventListener("enterFrame", self)
		for k, _ in pairs(self.timers) do
			timer.cancel(self.timers[k])
			self.timers[k] = nil
		end	
		for k, _ in pairs(self.transitions) do
			transition.cancel(self.transitions[k])
			self.transitions[k] = nil
		end
		for i = 1, #self.radicals do
			self.radicals[i]:removeSelf()
		end
		for i = 1, #self.vertices do
			self.vertices[i]:removeSelf()
		end
	end

	----------------------------------------------------------
	LatticeClass:init(o)

	return LatticeClass
end

return class
