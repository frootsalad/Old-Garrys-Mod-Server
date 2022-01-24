--[[
MGANGS - ACHIEVEMENTS CLIENTSIDE LOAD
Developed by Zephruz
]]

-- [[SHARED]]
include("modules/achievements/ach_config.lua") -- Config

-- [[CLIENT]]
include("cl_meta.lua")
include("cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Gang.InitData", "MG2.Gang.InitData.MODULE.ACHIEVEMENTS",
function(data, noreset)
	data.achievements = (noreset && data.achievements || {})
end)

--[[------------
	NETWORKING
--------------]]
net.Receive("MG.Send.GangAchievements",
function(len)
	local achName = net.ReadString()
	local achVal = net.ReadInt(32)

	if (!achName or !achVal) then return false end

	MGangs.Gang.Data.achievements[achName] = achVal
end)
