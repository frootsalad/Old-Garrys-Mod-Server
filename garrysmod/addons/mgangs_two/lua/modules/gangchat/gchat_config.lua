--[[
MGANGS - GANGCHAT CONFIG
Developed by Zephruz
]]

MG2_GANGCHAT.config = {}

MG2_GANGCHAT.config.msgSettings = {
	minLen = 1,													-- Minimum message length
	maxLen = 32,												-- Maximum message length
	prefix = {
		text = "[GANG CHAT]",							-- Prefix text
		color = Color(200,200,255),				-- Prefix color
	},
}

MG2_GANGCHAT.config.chatcmds = {
	["!gchat"] = true,		-- ["COMMAND"] = enabled (true or false),
	["!gangchat"] = true,
	["/gchat"] = true,
	["/gangchat"] = true,
}
