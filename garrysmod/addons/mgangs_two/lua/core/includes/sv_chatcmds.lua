--[[
	mGangs 2 Chat Commands [FIX]
	
	- This fixes the issue around chat commands and custom chat-boxes.
	- Custom chat-boxes like to claim the use of OnPlayerChat instead of allowing it to be utilized by anything else.
	- This uses PlayerSay instead, as a fix.
]]

local chatCmds = {
	-- [[Gang Related]]
	["!gang"] = "gang_menu",
	["!ganginvites"] = "gang_invites",
	["!gangcreate"] = "gangcreate_menu",
	["!creategang"] = "gangcreate_menu",
	
	-- [[Admin Related]]
	["!mgadmin"] = "gang_admin",
}

hook.Add( "PlayerSay", "MG2.PlayerSay.CHATCMDSFIX", function(ply, text) 
    for k,v in pairs(chatCmds) do
        if (text:lower() == k) then
            ply:ConCommand(v)
        end
    end
end)