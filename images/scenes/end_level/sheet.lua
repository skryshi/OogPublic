--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:a5bbdb403a80eaf8cdaeacd1603894fb:1/1$
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
            -- bar_black
            x=2,
            y=444,
            width=569,
            height=66,

        },
        {
            -- bar_black_rays
            x=2,
            y=2,
            width=570,
            height=315,

        },
        {
            -- button_menu
            x=426,
            y=319,
            width=82,
            height=65,

            sourceX = 14,
            sourceY = 13,
            sourceWidth = 112,
            sourceHeight = 89
        },
        {
            -- button_menu_pressed
            x=314,
            y=319,
            width=110,
            height=86,

            sourceX = 0,
            sourceY = 3,
            sourceWidth = 112,
            sourceHeight = 90
        },
        {
            -- button_next
            x=172,
            y=319,
            width=140,
            height=103,

            sourceX = 14,
            sourceY = 9,
            sourceWidth = 168,
            sourceHeight = 123
        },
        {
            -- button_next_pressed
            x=2,
            y=319,
            width=168,
            height=123,

        },
        {
            -- star_0
            x=510,
            y=380,
            width=167,
            height=59,

        },
        {
            -- star_1
            x=679,
            y=380,
            width=167,
            height=58,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 167,
            sourceHeight = 60
        },
        {
            -- star_2
            x=573,
            y=441,
            width=167,
            height=58,

            sourceX = 0,
            sourceY = 2,
            sourceWidth = 167,
            sourceHeight = 60
        },
        {
            -- star_3
            x=510,
            y=319,
            width=170,
            height=59,

        },
    },
    
    sheetContentWidth = 1024,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["bar_black"] = 1,
    ["bar_black_rays"] = 2,
    ["button_menu"] = 3,
    ["button_menu_pressed"] = 4,
    ["button_next"] = 5,
    ["button_next_pressed"] = 6,
    ["star_0"] = 7,
    ["star_1"] = 8,
    ["star_2"] = 9,
    ["star_3"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
