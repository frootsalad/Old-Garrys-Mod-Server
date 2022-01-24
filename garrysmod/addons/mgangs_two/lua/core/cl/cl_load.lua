--[[
MGANGS - CLIENTSIDE LOAD
Developed by Zephruz
]]

-- Load
include("mg_config.lua") 							-- Config
include("mg_includes.lua")						-- Includes
include("mg_languages.lua") 					-- Languages

-- Core
include("core/sh_util.lua") 					-- Util
include("core/sh_meta.lua") 					-- Meta
include("core/sh_permissions.lua") 		-- Permissions
include("core/sh_globals.lua") 				-- Globals
include("core/sh_settings.lua") 			-- Settings
include("core/cl/cl_meta.lua") 							-- Meta
include("core/cl/cl_networking.lua")				-- Networking
include("core/cl/derma/cl_derma_load.lua") 	-- Derma/VGUI

-- Modules
include("mg_modules.lua")							-- Modules

-- [[Receive modules]]
net.Receive("MG2.Send.Modules",
function(len)
	local modPaths = net.ReadTable()

	for i=1,#modPaths do
		local mod = modPaths[i]
		include("modules/" .. mod .. "/module_load.lua")
	end

	hook.Run("MG2.Modules.Loaded")
end)

hook.Add("MG2.Modules.Loaded", "MG2.Modules.Loaded.DEFAULT",
function()
	MGangs.Gang:InitData(true)
end)
