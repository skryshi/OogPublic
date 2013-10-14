--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:b97ae018f5b02d0accc22df3654dd696:1/1$
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
            width=480,
            height=320,

        },
        {
            -- button_play
            x=154,
            y=324,
            width=126,
            height=97,

            sourceX = 11,
            sourceY = 7,
            sourceWidth = 150,
            sourceHeight = 113
        },
        {
            -- button_play_pressed
            x=2,
            y=324,
            width=150,
            height=116,

            sourceX = 1,
            sourceY = 0,
            sourceWidth = 152,
            sourceHeight = 116
        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["bg"] = 1,
    ["button_play"] = 2,
    ["button_play_pressed"] = 3,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
