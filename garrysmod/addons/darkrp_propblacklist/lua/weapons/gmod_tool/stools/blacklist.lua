 
TOOL.Category = "Falco Prop Protection"
TOOL.Name = "#tool.blacklist.name"
TOOL.Command = nil
TOOL.ConfigName = ""
TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
	{ name = "reload" },
} 
DFFP = DFFP or {}

local meta = FindMetaTable("Player")

function meta:HasToolAccess()

	return table.HasValue(DFFP.Config.toolAccess, self:GetUserGroup())

end

if ( CLIENT ) then
	language.Add( "tool.blacklist.name", "Blacklist Model" )
	language.Add( "tool.blacklist.desc", "Adjust blacklist settings for models." )
    language.Add("tool.blacklist.left", "Blacklist a model. Left click on a blacklisted model will despawn it.")
    language.Add("tool.blacklist.right", "Remove model from blacklist.")
    language.Add("tool.blacklist.reload", "Toggles spawning of blocked models.")
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.blacklist.desc" } )

end

function TOOL:LeftClick(trace)

	if ( !IsValid(trace.Entity) ) then return false end
	if ( CLIENT ) then return true end
	DFPP.BlacklistProp(trace, self:GetOwner())

end

function TOOL:RightClick(trace)

	if ( !IsValid(trace.Entity) ) then return false end
	if ( CLIENT ) then return true end
	DFPP.UnblacklistProp(trace, self:GetOwner())
end

function TOOL:Reload(trace)

	if ( CLIENT ) then return false end
	if (SERVER ) then 
	DFPP.ToggleBlockedProps(self:GetOwner())
end
end


if (SERVER) then

	function TOOL:Think()

		local ply = self:GetOwner()
		if not ply:HasToolAccess() then return end -- If they don't have access don't network what they don't need!
		DFPP.SendBlockedProps(ply)

	end


end


if (CLIENT ) then

  surface.CreateFont( "blacklist_24", {font = "Arial", extended = false, size = 24, weight = 500,blursize = 0,scanlines = 0,antialias = true,} )
  surface.CreateFont( "blacklist_20", {font = "Arial", extended = false, size = 20, weight = 500,blursize = 0,scanlines = 0,antialias = true,} )
  surface.CreateFont( "blacklist_16", {font = "Arial", extended = false, size = 16, weight = 500,blursize = 0,scanlines = 0,antialias = true,} )
  surface.CreateFont( "blacklist_12", {font = "Arial", extended = false, size = 12, weight = 500,blursize = 0,scanlines = 0,antialias = true,} )


local models = {}
local cacheEnts = cacheEnts or {}
local GetBlockedModels = function(len)
    local data = net.ReadData(len)
    models = string.Explode('\0', util.Decompress(data)) --Retreive models from server, store then in table every second.
end

net.Receive("DFPP_SendBlockedModels", GetBlockedModels)
local TrackedEnts =
{
	[ "prop_physics" ] = true,
	[ "prop_ragdoll" ] = true
}

hook.Add( "OnEntityCreated", "SoftEntList", function( ent )
	if ( not ( ent:IsValid() and TrackedEnts[ ent:GetClass() ] ) ) then return end

	cacheEnts[ ent:EntIndex() ] = ent

	for k,v in pairs(cacheEnts) do
		if not IsValid(cacheEnts[k]) then
			cacheEnts[k] = nil
		end
	end

end )


local blacklistedpng = Material("icon16/cancel.png")
local notlistedpng = Material("icon16/accept.png")
local massivepng = Material("icon16/error.png")
local img = notlistedpng
local listed = "Not Black Listed"
local a = 255
local red = Color(237, 61, 70,a)
local white = Color(255,255,255,a)
local color = Color(255,255,255,a)
local function ShowBlacklistStatus()
	
	local ply = LocalPlayer()
	if not cacheEnts then return end

for k,v in pairs(cacheEnts) do 
	if IsValid(v) then
		local d = math.Round(ply:GetPos():Distance(v:GetPos()))
	if d < 2500 then --Check distance so we don't draw every single prop on the map YUCK
		local mdl = v:GetModel()
		if not table.HasValue(DFFP.Config.espIgnore, mdl) then --Check if it's something we want to ignore
		local blackListed = table.HasValue(models, mdl)
		local pos = v:GetPos():ToScreen() --Take position of entity convert it to screen position
			if blackListed then	
				img = blacklistedpng
				listed = "Black Listed"
				color = red
			else 
				img = notlistedpng
				listed = "Not Black Listed"
				color = white
			end
			surface.SetDrawColor(white)
			surface.SetMaterial(img)
			surface.DrawTexturedRect(pos.x - 8, pos.y, 16, 16)
			draw.SimpleTextOutlined(listed, "blacklist_20", pos.x, pos.y - 15, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			if v:GetModelRadius() > 120 then
			draw.SimpleTextOutlined("Massive Prop", "blacklist_20", pos.x, pos.y - 30, red, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			surface.SetMaterial(massivepng)
			surface.DrawTexturedRect(pos.x - 64, pos.y - 38, 16, 16)
			surface.DrawTexturedRect(pos.x + 50, pos.y - 38, 16, 16)
			end
		end
	end

	end

end

end

function TOOL:DrawHUD()

	if not self:GetOwner():HasToolAccess() then return end
	ShowBlacklistStatus()

end


end