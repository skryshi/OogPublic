-- Copyright 2013 Arman Darini

local sceneName = "main_menu"
local scene = _storyboard.newScene()
local layers
local sheetInfo
local sheet
local timers = {}

----------------------------------------------------------
local function setSheet(imagePath)
	local imagePath = imagePath or "images/scenes/"..sceneName.."/sheet.png"
	local infoPath, _ = string.gsub(imagePath, "/", ".")
	infoPath = string.sub(infoPath, 1, #infoPath - 4)
	sheetInfo = require(infoPath)
	sheet = graphics.newImageSheet(imagePath, sheetInfo:getSheet())		
end

----------------------------------------------------------
local function showBackground()
	local frame = sheetInfo:getFrameIndex("bg")
	layers.content.bg = display.newImageRect(layers.content, sheet, frame, sheetInfo:getSheet().frames[frame].width, sheetInfo:getSheet().frames[frame].height)
	layers.content.bg:setReferencePoint(display.CenterReferencePoint)
	layers.content.bg.x = _game.centerX
	layers.content.bg.y = _game.centerY
end

----------------------------------------------------------
local function showContinueButton()
	layers.content.continueButton = _widget.newButton
	{
		sheet = sheet,
		defaultFrame = sheetInfo:getFrameIndex("button_play"),
		overFrame = sheetInfo:getFrameIndex("button_play_pressed"),
		left = _game.centerX,
		top = _game.centerY + 40,
		onRelease = function()
			if true == _game.controlsBlocked then return end
			audio.play(_sounds.click, { channel = 1, onComplete = function()
				_storyboard.gotoScene("scenes.play_level")
			end })
			return true
		end	
	}
	layers.content:insert(layers.content.continueButton)
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
	
	setSheet()

	showBackground()
	showContinueButton()
end

----------------------------------------------------------
function scene:willEnterScene(event)
end

----------------------------------------------------------
function scene:exitScene(event)
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