--[[
MGANGS - GANGCHAT SERVERSIDE LOAD
Developed by Zephruz
]]

--[[ SHARED ]]
include("modules/gangchat/gchat_config.lua") -- Config (SV)
AddCSLuaFile("modules/gangchat/gchat_config.lua") -- Config (CL)

--[[------------
	SETUP HOOKS
--------------]]
hook.Add("MG2.Send.GangData", "MG2.Send.GangData.MODULE.GANGCHAT", function(ply) end)

--[[------------
	NETWORKING
--------------]]
util.AddNetworkString('MG2.Send.GangChatMessage')

hook.Add("PlayerSay", "MG2.PlayerSay.MODULE.GANGCHAT",
function(ply, msg, tChat)
	if !(IsValid(ply)) then return false end

	if !(tChat) then
		local hasGang = ply:HasGang()
		local maxLen, minLen = (MG2_GANGCHAT.config.msgSettings && MG2_GANGCHAT.config.msgSettings.maxLen || 32), (MG2_GANGCHAT.config.msgSettings && MG2_GANGCHAT.config.msgSettings.minLen || 5)
		local chatCmds = (MG2_GANGCHAT && MG2_GANGCHAT.config && MG2_GANGCHAT.config.chatcmds or {
			["!gchat"] = true,
			["!gangchat"] = true,
			["/gchat"] = true,
			["/gangchat"] = true,
		})

		for cmd,enabled in pairs(chatCmds) do
			if (msg && msg:StartWith(cmd) && enabled) then
				msg = msg:Right(#msg - #cmd)
				msg = msg:Trim()

				if !(hasGang) then ply:MG_SendNotification(MGangs.Language:GetTranslation("youre_not_ina_gang")) return "" end

				if (#msg < minLen || #msg > maxLen) then
					ply:MG_SendNotification(MGangs.Language:GetTranslation("gc_message_wrongsize", maxLen, minLen))

					return ""
				end

				net.Start("MG2.Send.GangChatMessage")
					net.WriteEntity(ply)
					net.WriteString(msg)
				net.Send(MGangs.Gang:GetOnlineMembers(ply:GetGangID()))

				return ""
			end
		end
	end
end)
