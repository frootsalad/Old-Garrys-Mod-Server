if (not party) then return end

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Chat"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSChat","partychat",function(ply,party,txt)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " (" .. bLogs:Highlight(party.name) .. "): " .. txt)
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Created"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSStartParty","partycreated",function(ply,party)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " created party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Joined"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSJoinParty","partyjoined",function(ply,party)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " joined party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Join Requests"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSRequestJoin","partyreq",function(ply,party)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " requested to join party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Invites"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSPartyInvite","partyinv",function(ply,party,ply2)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " invited " .. bLogs:FormatPlayer(ply2) .. " to party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Left"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSLeaveParty","partyleave",function(ply,party)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " left party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Kicks"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSKickedParty","partykick",function(ply,ply2,party)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " kicked " .. bLogs:FormatPlayer(ply2) .. " from party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Disbanded"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSDisbandedParty","partydisbanded",function(ply,party)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " disbanded party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)

-----------------------------------------------------------------

local MODULE = bLogs:Module()

MODULE.Category = "Simple Party System"
MODULE.Name     = "Party Leader Left"
MODULE.Colour   = Color(150,0,255)

MODULE:Hook("SPSPartyLeaderLeft","partyleaderleft",function(ply,party)
	MODULE:Log(bLogs:FormatPlayer(ply) .. " left the server and abandoned their party " .. bLogs:Highlight(party.name))
end)

bLogs:AddModule(MODULE)
