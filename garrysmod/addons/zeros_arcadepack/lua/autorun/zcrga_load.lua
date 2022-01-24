include("zcrga/sh/zcrga_config.lua")
AddCSLuaFile("zcrga/sh/zcrga_config.lua")

local function zcrga_LoadAllFiles(fdir)
	local files, dirs = file.Find(fdir .. "*", "LUA")

	for _, afile in ipairs(files) do
		if string.match(afile, ".lua") then
			if SERVER then
				AddCSLuaFile(fdir .. afile)
			end

			include(fdir .. afile)
		end
	end

	for _, dir in ipairs(dirs) do
		zcrga_LoadAllFiles(fdir .. dir .. "/")
	end
end

--zcrga_LoadAllFiles( "zcrga_languages/" )
zcrga_LoadAllFiles("zcrga/")
