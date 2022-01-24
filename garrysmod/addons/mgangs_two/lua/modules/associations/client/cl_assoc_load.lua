--[[
MGANGS - ASSOCIATIONS CLIENTSIDE LOAD
Developed by Zephruz
]]

-- [[SHARED]]
include("modules/associations/assoc_config.lua") -- Config

-- [[CLIENT]]
include("cl_meta.lua")
include("cl_derma.lua")

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Gang.InitData", "MG2.Gang.InitData.MODULE.ASSOCIATIONS",
function(data, noreset)
	data.associations = (noreset && data.associations || {})
end)

--[[------------
	NETWORKING
--------------]]
net.Receive("MG.Send.GangAssociations",
function(len)
	local curSplit = net.ReadInt(32)
	local gangAss = net.ReadTable()

	if (curSplit == 1) then
		MGangs.Gang.Data.associations = gangAss
	else
		table.Merge(MGangs.Gang.Data.associations,gangAss)
	end
end)
