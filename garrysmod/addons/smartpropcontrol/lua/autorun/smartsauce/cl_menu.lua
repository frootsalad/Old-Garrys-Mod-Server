//
/*
	Menu
	3/2/2018
	Jax✸
*/

/*
	Plugins
*/

local smartDerma = include("plugins/cl_derma.lua");
smartDerma:SetTransitionDuration(0.2);

/*
	Menu
*/
local menu = {
	
	zoneMaterial = Material("models/wireframe"),
	bRenderGhostZones = false,
	data = {
		
		ghostZones = {},
	},
	lastTab = smartsauce_config.lang.tabTitle,
};

/*
	Handles networking to the server 
*/
function menu:Edit(action, data)

	net.Start("smartsauce_edit");
		
		net.WriteTable({
			action = action,
			data = data,
		});
	net.SendToServer();
end 

/*
	Main menu 
*/
function menu:Open()

	local frame = smartDerma:Frame(nil, nil, 600, 500, smartsauce_config.lang.menuTitle);
	frame:MakePopup();

	local sheet = smartDerma:PropertySheet();
	sheet:SetParent(frame);
	sheet:SetPos(5, 25);
	sheet:SetSize(frame:GetWide() - 10, frame:GetTall() - 30);

	// Main config tab
	local mainTab = smartDerma:Panel();

	local mList = smartDerma:List();
	mList:SetParent(mainTab);
	mList:SetPos(0, 10);
	mList:SetSize(sheet:GetWide() - 20, sheet:GetTall() - 10);
	mList:SetPadding(10);

	local propGhosting = smartDerma:DropDownSheet(smartsauce_config.lang.propGhosting, {"Enabled", "Disabled"}, self.data.bGhostProps && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)

		if (value == "Enabled") then 
			self.data.bGhostProps = true;
		else 
			self.data.bGhostProps = false;
		end
	end);
	mList:AddItem(propGhosting);

	local propDamage = smartDerma:DropDownSheet(smartsauce_config.lang.propDamage, {"Enabled", "Disabled"}, self.data.bPropDamage && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bPropDamage = true;
		else 
			self.data.bPropDamage = false;
		end
	end);
	mList:AddItem(propDamage);

	local antiCrash = smartDerma:DropDownSheet(smartsauce_config.lang.antiCrash, {"Enabled", "Disabled"}, self.data.bAntiCrash && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bAntiCrash = true;
		else 
			self.data.bAntiCrash = false;
		end
	end);
	mList:AddItem(antiCrash);
	
	local noCollide = smartDerma:DropDownSheet(smartsauce_config.lang.nocollide, {"Enabled", "Disabled"}, self.data.bNoCollide && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bNoCollide = true;
		else 
			self.data.bNoCollide = false;
		end
	end);
	mList:AddItem(noCollide);
	
	local vehicleDamage = smartDerma:DropDownSheet(smartsauce_config.lang.vehicleDamage, {"Enabled", "Disabled"}, self.data.bVehicleDamage && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bVehicleDamage = true;
		else 
			self.data.bVehicleDamage = false;
		end
	end);
	mList:AddItem(vehicleDamage);
	
	local gravPunt = smartDerma:DropDownSheet(smartsauce_config.lang.gravPunt, {"Enabled", "Disabled"}, self.data.bGravgunPunt && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bGravgunPunt = true;
		else 
			self.data.bGravgunPunt = false;
		end
	end);
	mList:AddItem(gravPunt);
	
	local decal = smartDerma:DropDownSheet(smartsauce_config.lang.decalClean, {"Enabled", "Disabled"}, self.data.bDecalClean && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bDecalClean = true;
		else 
			self.data.bDecalClean = false;
		end
	end);
	mList:AddItem(decal);
	
	local physgunUnfreeze = smartDerma:DropDownSheet(smartsauce_config.lang.physgunReload, {"Enabled", "Disabled"}, self.data.bPhysgunUnfreeze && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bPhysgunUnfreeze = true;
		else 
			self.data.bPhysgunUnfreeze = false;
		end
	end);
	mList:AddItem(physgunUnfreeze);
	
	local antiSpam = smartDerma:DropDownSheet(smartsauce_config.lang.antiPropSpam, {"Enabled", "Disabled"}, self.data.bAntiSpam && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bAntiSpam = true;
		else 
			self.data.bAntiSpam = false;
		end
	end);
	mList:AddItem(antiSpam);
	
	local propsInProps = smartDerma:DropDownSheet(smartsauce_config.lang.propsInProps, {"Enabled", "Disabled"}, self.data.bPropsInProps && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bPropsInProps = true;
		else 
			self.data.bPropsInProps = false;
		end
	end);
	mList:AddItem(propsInProps);
	
	local ghostGravGun = smartDerma:DropDownSheet(smartsauce_config.lang.ghostOnGravGun, {"Enabled", "Disabled"}, self.data.bGhostGravGun && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bGhostGravGun = true;
		else 
			self.data.bGhostGravGun = false;
		end
	end);
	mList:AddItem(ghostGravGun);
	
	local inVehicleDmg = smartDerma:DropDownSheet(smartsauce_config.lang.damageInVehicles, {"Enabled", "Disabled"}, self.data.bInVehicleDamage && 1 || 2, sheet:GetWide(), 20, function(s, index, value, data)
		if (value == "Enabled") then 
			self.data.bInVehicleDamage = true;
		else 
			self.data.bInVehicleDamage = false;
		end
	end);
	mList:AddItem(inVehicleDmg);

	mList:AddItem(smartDerma:Button(smartsauce_config.lang.save, function()
		self:Edit("main_save", {
		
			bGhostProps = self.data.bGhostProps,
			bPropDamage = self.data.bPropDamage,
			bAntiCrash = self.data.bAntiCrash,
			bNoCollide = self.data.bNoCollide,
			bVehicleDamage = self.data.bVehicleDamage,
			bGravgunPunt = self.data.bGravgunPunt,
			bDecalClean = self.data.bDecalClean,
			bPhysgunUnfreeze = self.data.bPhysgunUnfreeze,
			bAntiSpam = self.data.bAntiSpam,
			bPropsInProps = self.data.bPropsInProps,
			bGhostGravGun = self.data.bGhostGravGun,
			bInVehicleDamage = self.data.bInVehicleDamage,
		});
		frame.Dismiss();
	end));

	local sheet1 = sheet:AddSheet(smartsauce_config.lang.tabTitle, mainTab, "icon16/page.png");

	// Blacklist tab

	local blacklistTab = smartDerma:Panel();
	local bList = smartDerma:List();
	bList:SetParent(blacklistTab);
	bList:Dock(FILL);

	local bSelectedClass = nil;
	local bClasses = vgui.Create("DListView");
	bClasses:SetTall(200);
	bClasses.OnRowSelected = function(s, rowIndex, row)

		bSelectedClass = row:GetColumnText(1);
	end

	bClasses:AddColumn("Class");
	
	for k,v in next, self.data.physgunGhostList do 
		bClasses:AddLine(k);
	end

	bList:AddItem(bClasses);
	
	local classEntryLab = smartDerma:Label(smartsauce_config.lang.enterEntityClass, "Trebuchet18");
	bList:AddItem(classEntryLab);
	
	local classEntry = vgui.Create("DTextEntry");
		
	bList:AddItem(classEntry);
	
	local bAdd = smartDerma:Button(smartsauce_config.lang.add, function()
		local class = classEntry:GetValue();
		if (#class < 1) then return end 
		
		self:Edit("add_blacklist", {
			class = class,
		});
		frame.Dismiss();
	end);
	bList:AddItem(bAdd);

	local bRemove = smartDerma:Button(smartsauce_config.lang.remove, function()
		if (bSelectedClass == nil) then return end

		self:Edit("remove_blacklist", {
			class = bSelectedClass
		});
		frame.Dismiss();
	end);

	bList:AddItem(bRemove);
	
	bList:AddItem(smartDerma:Button(smartsauce_config.lang.save, function()
		self:Edit("save", {});
		frame.Dismiss();
	end));

	local sheet2 = sheet:AddSheet(smartsauce_config.lang.tab2Title, blacklistTab, "icon16/cross.png");

	// Ghost Zone Tab 
	local ghostZone = smartDerma:Panel();
	local zList = smartDerma:List();
	zList:SetParent(ghostZone);
	zList:Dock(FILL);

	local zSelectedIndex = nil;
	local zZones = vgui.Create("DListView");
	zZones:SetTall(200);
	zZones.OnRowSelected = function(s, rowIndex, row)
		
		zSelectedIndex = rowIndex;
	end

	zZones:AddColumn("Zone");

	for k,v in next, self.data.ghostZones do 
		zZones:AddLine("Zone: " .. k);
	end

	zList:AddItem(zZones);

	local zRemove = smartDerma:Button(smartsauce_config.lang.remove, function()
		if (zSelectedIndex == nil) then return end
		
		self:Edit("remove_ghostzone", {
			index = zSelectedIndex,
		});
		frame.Dismiss();
	end )
	zList:AddItem(zRemove);

	local zDraw = smartDerma:Button(self.bRenderGhostZones && smartsauce_config.lang.disableGhostRendering || smartsauce_config.lang.enableGhostRendering);
	zDraw.DoClick = function()
		self.bRenderGhostZones = !self.bRenderGhostZones; // toggle dat shit 
		if (self.bRenderGhostZones) then 
			zDraw:SetText("Disable Ghost Zone Rendering");
		else 
			zDraw:SetText("Enable Ghost Zone Rendering");
		end
	end
	zList:AddItem(zDraw);
	
	zList:AddItem(smartDerma:Button(smartsauce_config.lang.save, function()
		self:Edit("save", {});
		frame.Dismiss();
	end));
	
	local sheet3 = sheet:AddSheet(smartsauce_config.lang.tab3Title, ghostZone, "icon16/map.png");
	
	// Lag Data tab 
	local lagDataTab = smartDerma:Panel();
	local lagList = smartDerma:List();
	lagList:SetParent(lagDataTab);
	lagList:SetPos(0, 10);
	lagList:SetSize(sheet:GetWide() - 20, sheet:GetTall() - 10);
	lagList:SetPadding(10);
	
	local axisPadding = 20;
	local graph = smartDerma:LineGraph(smartsauce_config.lang.collisionsPerSecond, 
										smartsauce_config.lang.time,
										lagList:GetWide(), 300, 30, 
										self.data.lagData, 
										smartsauce_config.physicsEvaulationInterval, 
										smartsauce_config.graphYAxisInterval);

	graph:AddThreshold(self.data.cleanupThreshold, smartsauce_config.lang.crashWarning, Color(255, 50, 50, 255));
	graph:AddThreshold(math.floor(self.data.cleanupThreshold/2), smartsauce_config.lang.healthyLag, Color(50, 255, 50, 255));
	
	lagList:AddItem(graph);
	
	local cleanupThresholdSlider = smartDerma:NumSlider(50, 1500, 0);
	cleanupThresholdSlider:SetTall(20);
	cleanupThresholdSlider.Label:SetText(smartsauce_config.lang.antiCrashThreshold);
	cleanupThresholdSlider:SetValue(self.data.cleanupThreshold);
	lagList:AddItem(cleanupThresholdSlider);
	
	local unfreezeThresholdSlider = smartDerma:NumSlider(10, 50, 0);
	unfreezeThresholdSlider:SetTall(20);
	unfreezeThresholdSlider.Label:SetText(smartsauce_config.lang.unfreezeCrashThreshold);
	unfreezeThresholdSlider:SetValue(self.data.unfreezeThreshold);
	lagList:AddItem(unfreezeThresholdSlider);
	
	local fadingDoorThresholdSlider = smartDerma:NumSlider(10, 50, 0);
	fadingDoorThresholdSlider:SetTall(20);
	fadingDoorThresholdSlider.Label:SetText(smartsauce_config.lang.fadingDoorCrashThreshold);
	fadingDoorThresholdSlider:SetValue(self.data.fadingDoorThreshold);
	lagList:AddItem(fadingDoorThresholdSlider);
	
	local refresh = smartDerma:Button(smartsauce_config.lang.refresh, function()
		frame.Dismiss();
		RunConsoleCommand("say", smartsauce_config.menuCommand);
	end);
	
	lagList:AddItem(refresh);
	
	local saveGraph = smartDerma:Button(smartsauce_config.lang.save, function()
		
		self:Edit("graph_save", {
			cleanupThreshold = math.Round(cleanupThresholdSlider:GetValue()),
			unfreezeThreshold = math.Round(unfreezeThresholdSlider:GetValue()),
			fadingDoorThreshold = math.Round(fadingDoorThresholdSlider:GetValue()),
		});
		frame.Dismiss();
	end);
	
	lagList:AddItem(saveGraph);
	
	local sheet4 = sheet:AddSheet(smartsauce_config.lang.tab4Title, lagDataTab, "icon16/chart_line.png");
	
	
	// Remember tab
	frame.Think = function()
	
		if (sheet:GetActiveTab() == sheet1.Tab) then 
			menu.lastTab = smartsauce_config.lang.tabTitle;
		elseif(sheet:GetActiveTab() == sheet2.Tab) then 
			self.lastTab = smartsauce_config.lang.tab2Title;
		elseif(sheet:GetActiveTab() == sheet3.Tab) then 
			self.lastTab = smartsauce_config.lang.tab3Title;
		elseif(sheet:GetActiveTab() == sheet4.Tab) then 
			self.lastTab = smartsauce_config.lang.tab4Title;
		end 
	end
	
	sheet:SwitchToName(self.lastTab);
	
	sheet:DoPaintSetup();
	frame.Request();
end

/*
	Receives the open menu network message 
*/
function menu.ReceiveOpenMenu(len)

	menu.data = net.ReadTable();
	menu:Open();
end 
net.Receive("smartsauce_menu", menu.ReceiveOpenMenu);

/*
	Draws the ghost zones 
*/
function menu.DrawGhostZones()

	if (!menu.bRenderGhostZones) then return end 
	
	for k,v in next, menu.data.ghostZones do 
	
		render.SetMaterial(menu.zoneMaterial);
		render.DrawBox(v.mins, Angle(0,0,0), Vector(0, 0, 0), (v.maxs - v.mins), Color(255, 255, 255, 255), false);
	end
end 
hook.Add("PostDrawTranslucentRenderables", "smartsauce_drawzones", menu.DrawGhostZones);

function menu.DrawGhostZoneLabels()

	if (!menu.bRenderGhostZones) then return end 

	for k,v in next, menu.data.ghostZones do 
	
		local scrnPos = v.maxs:ToScreen();
		if (scrnPos.visible) then 
		
			draw.SimpleTextOutlined(smartsauce_config.lang.zone .. tostring(k), "Trebuchet24", scrnPos.x, scrnPos.y, color_white, 1, 1, 1, color_black);
		end 
	end
end 
hook.Add("HUDPaint", "smartsauce_drawzonelabels", menu.DrawGhostZoneLabels);
