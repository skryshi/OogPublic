-- Copyright 2013 Arman Darini

local sceneName = "play_level"
local physics = require("physics")
local scene = _storyboard.newScene()
local layers
local UIClass = require("views.ui_class")
local UI
local sheetInfo
local sheet
local timers = {}
local LatticeClass = require("scenes.lattice_class")
local lattice
local camera = require("views.camera_class").new()
local ExitClass = require("scenes.exit_class")
local exit

----------------------------------------------------------
local function setSheet(imagePath)
	local imagePath = imagePath or "images/scenes/"..sceneName.."/sheet.png"
	local infoPath, _ = string.gsub(imagePath, "/", ".")
	infoPath = string.sub(infoPath, 1, #infoPath - 4)
	sheetInfo = require(infoPath)
	sheet = graphics.newImageSheet(imagePath, sheetInfo:getSheet())		
end

----------------------------------------------------------
local function scoreListener(event)
	print("scoreListener", event.amount)
	_game.score = _game.score + event.amount
	UI:updateLevelBar()
end

----------------------------------------------------------
local function achievementPopupListener(event)
	local txt
	if event.amount >= 180 then
		txt = _game.achievements[5]
	elseif event.amount >= 90 then
		txt = _game.achievements[4]
	elseif event.amount >= 60 then
		txt = _game.achievements[3]
	elseif event.amount >= 30 then
		txt = _game.achievements[2]
	elseif event.amount >= 20 then
		txt = _game.achievements[1]
	else
		return
	end
	print("achievementPopupListener", event.amount, txt)
	UIClass:showAchievementPopup(txt, layers.overlay)
end


----------------------------------------------------------
local function levelCompleteListener(event)
	_game.score = _game.score + 1
	UI:updateMessageBox(_game.score.." of ".._game.levels[_player.currentLevel].stars[1].." saved")
	if _helpers.computeStars(_game.score, _player.currentLevel) > 0 then
		UI:showExitButton()
	end
end

----------------------------------------------------------
local function cameraListener(event)
	if "began" == event.phase then
		camera:startDrag()
		display.getCurrentStage():setFocus(event.target)
	elseif "moved" == event.phase then
		camera:drag(event.x - event.xStart, event.y - event.yStart)
	elseif "ended" == event.phase or "cancelled" == event.phase then
		camera:endDrag()
		display.getCurrentStage():setFocus(nil)
		print("camera", camera.x, camera.y)
	end
	return true
end

----------------------------------------------------------
local function exitListener(event)
	print("******: exitListener")
	if false == _game.levelCompleted and "vertex" == event.other.name and "began" == event.phase then
		timer.performWithDelay(10, function()
			_game.levelCompleted = true
			audio.play(_sounds.reach_exit, { channel = 1 })
			exit.joint = physics.newJoint("distance", exit, event.other, exit.x, exit.y, event.other.x, event.other.y)
			exit.joint.length = 20
			exit.joint.dampingRatio = 10
			exit.joint.frequency = 3
			exit:setState("active")
			lattice:attachToExit(event.other)
		end, 1)		
	end
end

----------------------------------------------------------
function scene:createScene(event)
	layers = display.newGroup()
	layers.content = display.newGroup()
	layers.ui = display.newGroup()
	layers.overlay = display.newGroup()
	layers:insert(layers.content)
	layers:insert(layers.ui)
	layers:insert(layers.overlay)
	self.view:insert(layers)
	
	-- init vars
	_game.score = 0
	_game.levelCompleted = false
	
	UI = UIClass.new({ layer = layers.ui, imagePath = "images/scenes/play_level/01/sheet.png" })
	UI:showBackground(layers.content)
	UI:showMessageBox()
	UI:updateMessageBox("0 of ".._game.levels[_player.currentLevel].stars[1].." saved")
	UI:showRestartButton()
--	UI:showExitButton()

	physics.start()
	physics.setGravity(0, 9.8)
--	physics.setDrawMode("hybrid")
	
-- place ground
	setSheet("images/scenes/play_level/01/sheet.png")
--	local physicsData = (require "images.scenes.play_level.01.shapes").physicsData(1)
	local frame = sheetInfo:getFrameIndex("ground")
	layers.content.ground = display.newImageRect(layers.content, sheet, frame, sheetInfo:getSheet().frames[frame].width, sheetInfo:getSheet().frames[frame].height)
	local physicsData = _utils.getPhysicsData("images.scenes.play_level.01.shapes", "images.scenes.play_level.01.sheet", 1)
	physics.addBody(layers.content.ground, "static", physicsData:get("ground"))
	layers.content.ground.x = _game.centerX
	layers.content.ground.y = _game.centerY + 480
	
	-- place exit
	exit = ExitClass.new({ layer = layers.content, state = "default" })
	exit.x = _game.centerX
	exit.y = 100
	exit:addEventListener("collision", exitListener)

	-- setup camera
	camera:init({ x = _game.centerX, y = 0, layer = layers.content, viewable = { xMin = 0, yMin = 0, xMax = _game.w, yMax = 550 }})
	camera:panTo(_game.centerX, _game.centerY + 250)
	layers:addEventListener("touch", cameraListener)

	-- place initial goo structure
	lattice = LatticeClass.new({ layer = display.newGroup(), camera = camera })
	layers.content:insert(lattice:getLayer())
	timer.performWithDelay(3000, function()
		lattice:addStructure({ vertices = { { 130, 100, 1 }, { 300, 150, 1 }, { 100, 150, 1 } }, edges = { { 1, 2 }, { 2, 3 }, { 3, 1 } } })
		lattice:addRadicals(15)
	end, 1)
		
	-- add listeners
	Runtime:addEventListener("oogCollected", levelCompleteListener)
end

----------------------------------------------------------
function scene:willEnterScene(event)
end

----------------------------------------------------------
function scene:exitScene(event)
	Runtime:removeEventListener("oogCollected", levelCompleteListener)
	lattice:removeSelf()
	exit:removeSelf()
	camera:removeSelf()
	

	for k, _ in pairs(timers) do
		timer.cancel(timers[k])
		timers[k] = nil
	end	
end

----------------------------------------------------------
scene:addEventListener("createScene", scene)
scene:addEventListener("willEnterScene", scene)
scene:addEventListener("exitScene", scene)

return scene