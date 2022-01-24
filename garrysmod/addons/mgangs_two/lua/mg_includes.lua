--[[
MGANGS - INCLUDES SERVER
Developed by Zephruz

- Does not iterate into directories past includes/
	* Means it only allows *.lua files, one-file includes; sorry.
]]

--[[-------------
	Include Meta
----------------]]
MGangs.Include._path = {"addons", "mgangs_two", "lua", "core", "includes"}
MGangs.Include._cache = (MGangs.Include._cache or {})

local path = MGangs.Include._path
local rPath = path[#MGangs.Include._path - 1] .. "/" .. path[#MGangs.Include._path]

function MGangs.Include:LoadServer()
	local f,d = file.Find(table.concat(path, "/") .. "/*", "GAME")

	local fTypes = {
		["sh_"] = {cl = true, sv = true},
		["sv_"] = {sv = true},
		["cl_"] = {cl = true},
	}

	for k,v in pairs(f) do
		for fStr, fDta in pairs(fTypes) do
			if (v:StartWith(fStr)) then
				if (fDta.sv) then include(rPath .. "/" .. v) end
				if (fDta.cl) then AddCSLuaFile(rPath .. "/" .. v) end
			else
				AddCSLuaFile(rPath .. "/" .. v)
			end
		end
	end

	hook.Run("MG2.Include.Loaded")
end

function MGangs.Include:LoadClient()
	local f,d = file.Find(rPath .. "/*", "LUA")

	for k,v in pairs(f) do
		include(rPath .. "/" .. v)
	end

	hook.Run("MG2.Include.Loaded")
end

if (SERVER) then MGangs.Include:LoadServer() end
if (CLIENT) then MGangs.Include:LoadClient() end
