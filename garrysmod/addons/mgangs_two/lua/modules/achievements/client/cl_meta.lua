--[[
MGANGS - ACHIEVEMENTS CLIENTSIDE META
Developed by Zephruz
]]

MGangs.Meta:Register({"GetAchievements", "GetGangAchievements"}, MGangs.Gang,
function(self, name)
	return (name && MGangs.Gang.Data.achievements[name] || MGangs.Gang.Data.achievements)
end)
