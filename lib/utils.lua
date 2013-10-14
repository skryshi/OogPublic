-- Copyright 2013 Arman Darini

local json = require("json")

utils = {
	----------------------------------------------------------
	printTable = function(t)
		if nil == t then return end
		for k, v in pairs(t) do
			if "table" == type(v) then
				local s = ""
				for k2, v2 in pairs(v) do
					s = s .. ("table" ~= type(v2) and tostring(v2) or "{..}") .. " "
				end
				print(k, s)
			else
				print(k, v)
			end
		end
	end,

	----------------------------------------------------------
	printDisplayObject = function(obj)
		print("x="..obj.x, "y="..obj.y, "xOr="..obj.xOrigin, "yOr="..obj.yOrigin, "xRef="..obj.xReference, "yRef="..obj.yReference, "w="..obj.width, "h="..obj.height)
	end,

	----------------------------------------------------------
	printMemoryUsed = function()
	   collectgarbage( "collect" )
	   local memUsage = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
	   print( memUsage, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
	end,

	----------------------------------------------------------
	saveTable = function(t, filename)
		local path = system.pathForFile(filename, system.DocumentsDirectory)
		local file = io.open(path, "w")
		if file then
			local contents = json.encode(t)
			file:write(contents)
			io.close( file )
			return true
		else
			return false
		end
	end,

	----------------------------------------------------------
	loadTable = function(filename)
		local path = system.pathForFile( filename, system.DocumentsDirectory)
		local contents = ""
		local myTable = {}
		local file = io.open( path, "r" )
		if file then
			-- read all contents of file into a string
			local contents = file:read( "*a" )
			myTable = json.decode(contents);
			io.close( file )
			return myTable 
		end
		return nil
	end,

	----------------------------------------------------------
	copyTable = function(t)
	  local t2 = {}
	  for k,v in pairs(t) do
	    t2[k] = v
	  end
	  return t2
	end,

	----------------------------------------------------------
	distance = function(a, b)
		return ((a.x - b.x)^2 + (a.y - b.y)^2)^0.5
	end,

	----------------------------------------------------------
	getPhysicsData = function(shapesPath, sheetPath, scale)
		print("getPhysicsData")
		local scale = scale or 1
		local physicsData = (require(shapesPath)).physicsData(scale)
		local sheetInfo = require(sheetPath)
		local visualInfo

		for k, _ in pairs(physicsData.data) do
			visualInfo = sheetInfo:getSheet().frames[sheetInfo:getFrameIndex(k)]
			for i = 1, #physicsData.data[k] do
--				_utils.printTable(physicsData.data[k])
				for j = 1, #physicsData.data[k][i].shape do
					if 1 == j % 2 then	-- x coordinate
						physicsData.data[k][i].shape[j] = physicsData.data[k][i].shape[j] + sheetInfo:getSheet().sheetContentWidth / 2 - (visualInfo.x + visualInfo.width / 2)
					else	-- y coordinate
						physicsData.data[k][i].shape[j] = physicsData.data[k][i].shape[j] + sheetInfo:getSheet().sheetContentHeight / 2 - (visualInfo.y + visualInfo.height / 2)
					end
				end
			end
		end
		
		return physicsData
	end,

}

return utils
