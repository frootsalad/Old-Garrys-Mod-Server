--[[
MGANGS - MODULES SHARED
Developed by Zephruz
]]

--[[-------------
	Module Meta
----------------]]
MGangs.Module._path = {"lua", "modules"}
MGangs.Module._cache = (MGangs.Module._cache or {})

--[[Load modules (SH)]]
if (SERVER) then
	util.AddNetworkString('MG2.Send.Modules')

	function MGangs.Module:Load()
		local path = self._path[1] .. "/" .. self._path[2] .. "/"
		MGangs:ConsoleMessage("/----- Loading Modules -----\\", Color(0,255,0))
		local files, dirs = file.Find(path .. "*", "THIRDPARTY")

		for k,v in pairs(dirs) do
			local m_files, m_dirs = file.Find(path .. v .. "/*", "THIRDPARTY")

			if (table.HasValue(m_files, "module_load.lua")) then
				local fPath = self._path[2] .. "/" .. v .. "/module_load.lua"
				include(fPath)
				AddCSLuaFile(fPath)

				MGangs:ConsoleMessage("\t" .. v .. " Loaded", Color(0,255,0))
			end
		end

		hook.Run("MG2.Modules.Loaded")
	end

	function MGangs.Module:SendToPlayer(ply)
		local modPaths = {}

		-- Send module data
		for k,v in pairs(self.mods) do
			table.insert(modPaths, k)
		end

		net.Start("MG2.Send.Modules")
			net.WriteTable(modPaths)
		net.Send(ply)
	end

	hook.Add("MG2.Player.InitialSpawn.Start", "MG2.Module.PInitSpawn.Start",
	function(ply)
		MGangs.Module:SendToPlayer(ply) -- Send Modules
	end)
end

if (CLIENT) then end
