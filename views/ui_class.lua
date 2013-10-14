-- Copyright 2013 Arman Darini

local class = {}
class.new = function(o)
	local UIClass = {}
	UIClass.layer = nil
	UIClass.imagePath = nil
	UIClass.sheetUIInfo = nil
	UIClass.sheetUI = nil

	----------------------------------------------------------
	function UIClass:init(o)
		print("UIClass:init")
		o = o or {}
		self.layer = o.layer
		self.imagePath = o.imagePath or "images/scenes/default.png"
		self:setSheet(self.imagePath)
		return self
	end

	----------------------------------------------------------
	function UIClass:getLayer()
		return self.layer
	end
	
	----------------------------------------------------------
	function UIClass:setSheet(imagePath)
		local infoPath, _ = string.gsub(imagePath, "/", ".")
		infoPath = string.sub(infoPath, 1, #infoPath - 4)
		self.sheetUIInfo = require(infoPath)
		self.sheetUI = graphics.newImageSheet(imagePath, self.sheetUIInfo:getSheet())		
	end

	----------------------------------------------------------
	function UIClass:showBackground(layer, name)
		local layer = layer or self.layer
		local name = name or "bg"
		local frame = self.sheetUIInfo:getFrameIndex(name)
		layer.bg = display.newImageRect(layer, self.sheetUI, frame, self.sheetUIInfo:getSheet().frames[frame].width, self.sheetUIInfo:getSheet().frames[frame].height)
		layer.bg:setReferencePoint(display.CenterReferencePoint)
		layer.bg.x = _game.centerX
		layer.bg.y = _game.centerY
		return layer
	end

	----------------------------------------------------------
	function UIClass:showMessageBox()
		self.layer.messageBox = display.newText(self.layer, "", 0, 0, _game.font, 16)
		self.layer.messageBox:setTextColor(0)
		self.layer.messageBox.y = _game.h - 20
		self:updateMessageBox("")
	end

	----------------------------------------------------------
	function UIClass:updateMessageBox(text)
		self.layer.messageBox.text = text
		self.layer.messageBox:setReferencePoint(display.CenterReferencePoint)
		self.layer.messageBox.x = _game.centerX - 180
	end

	----------------------------------------------------------
	function UIClass:showExitButton()
		self.layer.exitButton = display.newGroup()
		self.layer:insert(self.layer.exitButton)
		self.layer.exitButton.button = _widget.newButton
		{
			sheet = self.sheetUI,
			defaultFrame = self.sheetUIInfo:getFrameIndex("button_continue"),
			overFrame = self.sheetUIInfo:getFrameIndex("button_continue_pressed"),
			onRelease = function()
				if true == _game.controlsBlocked then return end
				audio.play(_sounds.click, { channel = 1, onComplete = function()
					_storyboard.showOverlay("scenes.end_level", { isModal = true, effect = "fade", time = 1000 })
				end })
				return true
			end	
		}
		self.layer.exitButton:insert(self.layer.exitButton.button)
		self.layer.exitButton:scale(0.7, 0.7)
		self.layer.exitButton.x = 20 
		self.layer.exitButton.y = 20
	end

	----------------------------------------------------------
	function UIClass:showRestartButton()
		self.layer.restartButton = display.newGroup()
		self.layer:insert(self.layer.restartButton)
		self.layer.restartButton.button = _widget.newButton
		{
			sheet = self.sheetUI,
			defaultFrame = self.sheetUIInfo:getFrameIndex("button_restart"),
			overFrame = self.sheetUIInfo:getFrameIndex("button_restart_pressed"),
			onRelease = function()
				if true == _game.controlsBlocked then return end
				audio.play(_sounds.click, { channel = 1, onComplete = function()
					_storyboard.purgeScene("scenes.play_level")
					_storyboard.gotoScene("scenes.play_level")
				end })
				return true
			end	
		}
		self.layer.restartButton:insert(self.layer.restartButton.button)
		self.layer.restartButton:scale(0.5, 0.5)
		self.layer.restartButton.x = _game.w - 70 
		self.layer.restartButton.y = _game.h - 55
	end

	----------------------------------------------------------
	UIClass:init(o)

	return UIClass
end

return class