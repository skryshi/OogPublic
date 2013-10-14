-- Copyright 2013 Arman Darini

local sceneName = "end_level"
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
local function showBars()
	-- bottom bar
	local frame = sheetInfo:getFrameIndex("bar_black_rays")
	layers.content.barBottom = display.newImageRect(layers.content, sheet, frame, sheetInfo:getSheet().frames[frame].width, sheetInfo:getSheet().frames[frame].height)
	layers.content.barBottom:setReferencePoint(display.BottomCenterReferencePoint)
	layers.content.barBottom.x = _game.centerX
	layers.content.barBottom.y = _game.h

	-- top bar
	local frame = sheetInfo:getFrameIndex("bar_black")
	layers.content.barTop = display.newImageRect(layers.content, sheet, frame, sheetInfo:getSheet().frames[frame].width, sheetInfo:getSheet().frames[frame].height)
	layers.content.barTop:setReferencePoint(display.TopCenterReferencePoint)
	layers.content.barTop.x = _game.centerX
	layers.content.barTop.y = 0
end

----------------------------------------------------------
local function showScore()
	-- stars
	local stars = _helpers.computeStars(_game.score, _player.currentLevel)
	local frame = sheetInfo:getFrameIndex("star_"..stars)
	layers.content.stars = display.newImageRect(layers.content, sheet, frame, sheetInfo:getSheet().frames[frame].width, sheetInfo:getSheet().frames[frame].height)
	layers.content.stars:setReferencePoint(display.BottomCenterReferencePoint)
	layers.content.stars.x = _game.centerX
	layers.content.stars.y = 100

	-- message
	layers.content.message = display.newText(layers.content, "OOGs Saved", 0, 0, _game.font, 35)
	layers.content.message:setTextColor(0)
	layers.content.message:setReferencePoint(display.CenterReferencePoint)
	layers.content.message.x = _game.centerX
	layers.content.message.y = 130

	-- score
	layers.content.score = display.newText(layers.content, _game.score, 0, 0, _game.font, 60)
	layers.content.score:setTextColor(0)
	layers.content.score:setReferencePoint(display.CenterReferencePoint)
	layers.content.score.x = _game.centerX
	layers.content.score.y = 180
end

----------------------------------------------------------
local function showMenuButton()
	layers.content.menuButton = _widget.newButton
	{
		sheet = sheet,
		defaultFrame = sheetInfo:getFrameIndex("button_menu"),
		overFrame = sheetInfo:getFrameIndex("button_menu_pressed"),
		left = 100,
		top = 200,
		onRelease = function()
			if true == _game.controlsBlocked then return end
			audio.play(_sounds.click, { channel = 1, onComplete = function()
				_storyboard.gotoScene("scenes.main_menu")
			end })
			return true
		end	
	}
	layers.content:insert(layers.content.menuButton)
end

----------------------------------------------------------
local function showContinueButton()
	layers.content.continueButton = _widget.newButton
	{
		sheet = sheet,
		defaultFrame = sheetInfo:getFrameIndex("button_next"),
		overFrame = sheetInfo:getFrameIndex("button_next_pressed"),
		left = 270,
		top = 180,
		onRelease = function()
			if true == _game.controlsBlocked then return end
			audio.play(_sounds.click, { channel = 1, onComplete = function()
				_storyboard.purgeScene("scenes.play_level")
				_storyboard.hideOverlay()
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

	showBars()
	showScore()
	showMenuButton()
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