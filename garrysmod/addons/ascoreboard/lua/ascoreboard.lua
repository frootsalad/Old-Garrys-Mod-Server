if aScoreboard and aScoreboard.Base then
	aScoreboard.Base:Remove()
end

for k, v in pairs(player.GetAll()) do
	v.aScoreboardPanel = nil
end

function aScoreboardTime(time) --Modified function for returning UTime
	local tmp = time
	local s = tmp % 60
	tmp = math.floor(tmp / 60)
	local m = tmp % 60
	tmp = math.floor(tmp / 60)
	local h = tmp % 24

	return string.format("%02ih %02im %02is", h, m, s)
end

aScoreboard									= {}

include("ascoreboard/config.lua")

aScoreboard.Icons 							= {}
aScoreboard.Icons.Dashboard 				= Material("ascoreboard/home.png")
aScoreboard.Icons.PlayersButton 			= Material("ascoreboard/players.png")
aScoreboard.Icons.DarkRPButton 				= Material("ascoreboard/darkrp.png")

aScoreboard.Icons.RulesButton 				= Material("ascoreboard/rules.png")
aScoreboard.Icons.WebButton 				= Material("ascoreboard/website.png")
aScoreboard.Icons.DonateButton 				= Material("ascoreboard/donate.png")
aScoreboard.Icons.WorkshopButton 			= Material("ascoreboard/workshop.png")

aScoreboard.Icons.ProfileButton 			= Material("ascoreboard/profile.png")
aScoreboard.Icons.MessageButton 			= Material("ascoreboard/message.png")

if (string.find(string.lower(GAMEMODE.Name), "rp") or string.find(string.lower(GAMEMODE.Name), "purge")) and not DarkRP.disabledDefaults["modules"]["fadmin"] then
	aScoreboard.DarkRP = true
else
	aScoreboard.DarkRP = false
end

if GAMEMODE.Name == "Murder" then
	aScoreboard.Murder = true
else
	aScoreboard.Murder = false
end

aScoreboard.PaintScroll = function(panel)
	local scr 				= panel:GetVBar()
	scr.Paint 				= function() draw.RoundedBox(4, 0, 0, scr:GetWide(), scr:GetTall(), Color(62, 62, 62)) end
	scr.btnUp.Paint 		= function() end
	scr.btnDown.Paint 		= function() end
	scr.btnGrip.Paint 		= function() draw.RoundedBox(6, 2, 0, scr.btnGrip:GetWide()-4, scr.btnGrip:GetTall()-2, aScoreboard.Color) end
end

aScoreboard.HideScroll = function(panel)
	local scr 				= panel:GetVBar()
	scr.Paint 				= function() end
	scr.btnUp.Paint 		= function() end
	scr.btnDown.Paint 		= function() end
	scr.btnGrip.Paint 		= function() end
end


include("ascoreboard/cl_masterpanel.lua")
include("ascoreboard/cl_playerlist.lua")
include("ascoreboard/cl_murderlist.lua")
include("ascoreboard/cl_dashboard.lua")
include("ascoreboard/cl_websites.lua")
include("ascoreboard/cl_rules.lua")
include("ascoreboard/cl_darkrpcommands.lua")
include("ascoreboard/cl_playerinspect.lua")

include("ascoreboard/vgui/cl_circleavatar.lua")
include("ascoreboard/vgui/cl_circles.lua")
include("ascoreboard/vgui/cl_ascoreboardbutton.lua")
include("ascoreboard/vgui/cl_playerline.lua")
include("aScoreboard/vgui/cl_listcategory.lua")

hook.Remove("ScoreboardShow", "FAdmin_scoreboard")
hook.Remove("ScoreboardHide", "FAdmin_scoreboard")

function GAMEMODE:ScoreboardShow()
	if IsValid(aScoreboard.Base) then
		aScoreboard.Base:SetVisible(true)
	else
		aScoreboard.Base = vgui.Create("aScoreboardBase")
	end
	aScoreboard.Base:SetMouseInputEnabled(true)
end

function GAMEMODE:ScoreboardHide()
	if (IsValid(aScoreboard.Base)) then
		aScoreboard.Base:SetVisible(false)
	end
	aScoreboard.Base:SetMouseInputEnabled(false) 
	aScoreboard.Base:SetKeyboardInputEnabled(false) 
end

MsgC(Color(215, 85, 80), "[aScoreboard] ", Color(210, 210, 210), "Loaded aScoreboard by ", Color(215, 85, 80) ,"arie ", Color(210, 210, 210),"(STEAM_0:0:22593800)\n")