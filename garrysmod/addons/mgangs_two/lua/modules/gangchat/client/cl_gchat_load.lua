--[[
MGANGS - GANGCHAT CLIENTSIDE LOAD
Developed by Zephruz
]]

-- [[SHARED]]
include("modules/gangchat/gchat_config.lua") -- Config

--[[------------
	META
--------------]]
MGangs.Meta:Register({"ChatMessage", "NewChatMessage"}, MGangs.Gang,
function(self, ply, msg)
	if !(IsValid(ply)) then return false end

	local msgSettings = MG2_GANGCHAT.config.msgSettings
	local prefixCfg = (msgSettings && msgSettings.prefix)

	chat.AddText((prefixCfg.color or Color(255,255,255)), (prefixCfg.text or "[GANG CHAT]") .. " ", Color(255,255,255), ply:Nick() .. ": " .. msg)
end)

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Gang.InitData", "MG2.Gang.InitData.MODULE.GANGCHAT", function(data, noreset) end)

--[[------------
	NETWORKING
--------------]]
net.Receive("MG2.Send.GangChatMessage",
function(len)
	local ply = net.ReadEntity()
	local msg = net.ReadString()

	MGangs.Gang:ChatMessage(ply, msg)
end)
