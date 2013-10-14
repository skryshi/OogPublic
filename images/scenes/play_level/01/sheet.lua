--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:e9bab9460c69f50a98ff794d2fb9c78c:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- bg
            x=2,
            y=2,
            width=570,
            height=720,

        },
        {
            -- button_continue
            x=149,
            y=842,
            width=126,
            height=97,

            sourceX = 11,
            sourceY = 7,
            sourceWidth = 150,
            sourceHeight = 113
        },
        {
            -- button_continue_pressed
            x=2,
            y=724,
            width=150,
            height=116,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 152,
            sourceHeight = 116
        },
        {
            -- button_restart
            x=154,
            y=724,
            width=120,
            height=90,

            sourceX = 12,
            sourceY = 9,
            sourceWidth = 144,
            sourceHeight = 108
        },
        {
            -- button_restart_pressed
            x=2,
            y=842,
            width=145,
            height=109,

        },
        {
            -- exit_active_01
            x=440,
            y=724,
            width=80,
            height=76,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_active_02
            x=372,
            y=880,
            width=78,
            height=76,

            sourceX = 2,
            sourceY = 4,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_active_03
            x=359,
            y=802,
            width=80,
            height=76,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_active_04
            x=290,
            y=938,
            width=80,
            height=76,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_active_05
            x=358,
            y=724,
            width=80,
            height=76,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_active_06
            x=277,
            y=802,
            width=80,
            height=76,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_active_07
            x=276,
            y=724,
            width=80,
            height=76,

            sourceX = 0,
            sourceY = 4,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_01
            x=277,
            y=880,
            width=58,
            height=56,

            sourceX = 12,
            sourceY = 14,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_02
            x=74,
            y=953,
            width=66,
            height=64,

            sourceX = 9,
            sourceY = 10,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_03
            x=452,
            y=878,
            width=76,
            height=72,

            sourceX = 3,
            sourceY = 6,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_04
            x=208,
            y=941,
            width=80,
            height=78,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_05
            x=441,
            y=802,
            width=78,
            height=74,

            sourceX = 2,
            sourceY = 5,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_06
            x=2,
            y=953,
            width=70,
            height=68,

            sourceX = 6,
            sourceY = 8,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_07
            x=142,
            y=953,
            width=64,
            height=62,

            sourceX = 9,
            sourceY = 11,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- exit_default_08
            x=277,
            y=880,
            width=58,
            height=56,

            sourceX = 12,
            sourceY = 14,
            sourceWidth = 80,
            sourceHeight = 80
        },
        {
            -- ground
            x=574,
            y=2,
            width=1024,
            height=330,

        },
    },
    
    sheetContentWidth = 2048,
    sheetContentHeight = 1024
}

SheetInfo.frameIndex =
{

    ["bg"] = 1,
    ["button_continue"] = 2,
    ["button_continue_pressed"] = 3,
    ["button_restart"] = 4,
    ["button_restart_pressed"] = 5,
    ["exit_active_01"] = 6,
    ["exit_active_02"] = 7,
    ["exit_active_03"] = 8,
    ["exit_active_04"] = 9,
    ["exit_active_05"] = 10,
    ["exit_active_06"] = 11,
    ["exit_active_07"] = 12,
    ["exit_default_01"] = 13,
    ["exit_default_02"] = 14,
    ["exit_default_03"] = 15,
    ["exit_default_04"] = 16,
    ["exit_default_05"] = 17,
    ["exit_default_06"] = 18,
    ["exit_default_07"] = 19,
    ["exit_default_08"] = 20,
    ["ground"] = 21,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
