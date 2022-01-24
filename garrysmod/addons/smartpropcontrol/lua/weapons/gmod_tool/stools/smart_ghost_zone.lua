//
/*
	Smart Prop Control - Ghost Zone Tool 
	Smart Like My Shoe 
	3/3/2018
*/


TOOL.Category       = "Smart' s Tools";
TOOL.Name           = "#Smart Ghost Zone";
TOOL.Command        = nil;
TOOL.ConfigName     = "";
 
TOOL.ClientConVar["god"]			 	= "0";
TOOL.ClientConVar["arrest"]			 	= "0";

local zoneStart, zoneEnd, bZoneFinished;

function TOOL:LeftClick(trace)
	
	bZoneFinished = false;
	zoneStart = trace.HitPos;
	return true;
end

function TOOL:RightClick(trace)

	if (zoneStart != nil) then 
		
		bZoneFinished = true;
	end
	return true;
end 

function TOOL:Reload(trace)
	
	if (SERVER) then 
		if (bZoneFinished) then

			local bGod = tobool(self:GetClientInfo("god"));
			local bArrest = tobool(self:GetClientInfo("arrest"));
		
			hook.Call("smartsauce_addghostzone", nil, self:GetOwner(), zoneStart, zoneEnd, bGod, bArrest);
		end
	end
	bZoneFinished = false;
	zoneStart = nil;
	zoneEnd = nil;
end

function TOOL:Deploy()
end 

function TOOL:Holster()
end 

function TOOL:Think()

	if (zoneStart != nil && !bZoneFinished) then 
		
		local trace = self:GetOwner():GetEyeTrace();
		zoneEnd = trace.HitPos;
	end
end 

if (CLIENT) then 

	// Top left hud language strings
	language.Add("Tool.smart_ghost_zone.name", "Ghost Zones");
    language.Add("Tool.smart_ghost_zone.desc", "Place zones to force entity ghosting in an area.");
    language.Add("Tool.smart_ghost_zone.0", "Primary: Begin zone | Secondary: End zone | Reload: Create zone");
	
	// Undo language 
	//language.Add("Undone_smart_npc", "Undone Smart Npc!");
	
	// Derma utility methods 
	local function MakeLabel(text, font)
	
		font = font || "Trebuchet18";
	
		local l = vgui.Create("DLabel");
		l:SetText(text);
		l:SetFont(font);
		l:SetTextColor(color_black);
		l:SizeToContents();
		
		return l;
	end
	
	local function MakeCheckBoxLabel(text, convar)
	
		local l = vgui.Create("DCheckBoxLabel");
		l:SetText(text);
		l:SetFont("Trebuchet18");
		l:SetTextColor(color_black);
		l:SetConVar(convar);
		l:SizeToContents();
		
		return l;
	end
	
	// Control panel (derma)
	local function BuildCPanel(panel)
		panel:ClearControls();
		
		local cmd = MakeLabel(smartsauce_config.menuCommand);
		panel:AddItem(cmd);
		
		local god = MakeCheckBoxLabel("God Mode", "smart_ghost_zone_god");
		panel:AddItem(god);
		
		local arrest = MakeCheckBoxLabel("Anti Arrest", "smart_ghost_zone_arrest");
		panel:AddItem(arrest);
	end
	
	// Called when player selects this tool for the first time
    function TOOL.BuildCPanel(panel)

        BuildCPanel(panel);
    end
	
	local function UpdateCPanel()
	 local panel = controlpanel.Get("smart_ghost_zone");
        if (!panel) then 
			return;
		end
        BuildCPanel(panel);
    end
    concommand.Add("smart_ghost_tool_updatecpanel", UpdateCPanel);
	
	local mat = Material("models/wireframe");
	
	hook.Add("PostDrawTranslucentRenderables", "smartsauce_zonetool", function()
		
		if (zoneStart == nil || zoneEnd == nil) then return end
		render.SetMaterial(mat);
		render.DrawBox(zoneStart, Angle(0,0,0), Vector(0, 0, 0), (zoneEnd - zoneStart), Color(255, 255, 255, 255), false);
	end);
end