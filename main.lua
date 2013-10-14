-- Copyright 2013 Arman Darini

display.setStatusBar(display.HiddenStatusBar)

-- these are used almost everywhere, so make they global
_utils = require("lib.utils")
_math = require("lib.math2")
_helpers = require("lib.helpers")
_widget = require("widget")
_storyboard = require("storyboard")
_storyboard.purgeOnSceneChange = true

_game = {
	debug = false,
	w = display.contentWidth,
	h = display.contentHeight,
	centerX = display.contentCenterX,
	centerY = display.contentCenterY,
	font = "AveriaLibre-Bold",
	moveSensitivity = 100,
	controlsBlocked = false,
	achievements = { "Not Bad!", "Rockin' It!", "On Steroids!", "Unbelievable!", "Divine!" },
	exp = { 0, 100, 200, 400, 800, 1600, 3200, 6400, 12800 },
	level = 1,
	levelCompleted = false,
	levels = {
		{ stars = { 2, 3, 4 },
		},
	},
	score = 0,
}

--	init player
local playerDefaults = {
	soundVolume = 0.3,
	musicVolume = 1,
	exp = 0,
	credits = 100,
	currentLevel = 1,
	levels = {
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
		{ attempts = 0, highScore = 0 },
	},
	version = 4,
}

_player = _utils.loadTable("player")
if nil == _player or _player.version ~= playerDefaults.version then
	_player = playerDefaults
	_utils.saveTable("player")
end
_utils.printTable(player)

--	init sounds and music
_sounds = {
	click = audio.loadSound("sounds/scenes/click.mp3"),
	rescue_radical = audio.loadSound("sounds/scenes/play_level/rescue_radical2.mp3"),
	catch_radical = audio.loadSound("sounds/scenes/play_level/catch_radical.mp3"),
	place_radical = audio.loadSound("sounds/scenes/play_level/place_radical.mp3"),
	remove_vertex = audio.loadSound("sounds/scenes/play_level/remove_vertex.mp3"),
	reach_exit = audio.loadSound("sounds/scenes/play_level/reach_exit.mp3"),
}

audio.setVolume(_player.soundVolume, { channel = 1 })	--sfx
audio.setVolume(_player.musicVolume, { channel = 2 })	--music
--music = audio.loadStream("sounds/theme_song.mp3")
--audio.play(music, { channel = 2, loops=-1, fadein=1000 })

-- add debug
if _game.debug then
	timer.performWithDelay(1000, _utils.printMemoryUsed, 0)
end

--	start game
_storyboard.gotoScene("scenes.main_menu")
