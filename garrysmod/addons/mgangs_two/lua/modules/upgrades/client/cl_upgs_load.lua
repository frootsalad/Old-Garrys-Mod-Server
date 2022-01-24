--[[
MGANGS - UPGRADES CLIENTSIDE LOAD
Developed by Zephruz
]]

-- [[SHARED]]
include("modules/upgrades/upgs_config.lua") -- Config

-- [[CLIENT]]
include("cl_meta.lua")
include("cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Gang.InitData", "MG2.Gang.InitData.MODULE.UPGRADES",
function(data, noreset)
	data.upgrades = (noreset && data.upgrades || {})
end)

--[[------------
	NETWORKING
--------------]]
net.Receive("MG_SendGangUpgrades",
function(len)
	local upgName = net.ReadString()
	local upgVal = net.ReadInt(32)

	if (!upgName or !upgVal) then return false end

	MGangs.Gang.Data.upgrades[upgName] = upgVal
end)
