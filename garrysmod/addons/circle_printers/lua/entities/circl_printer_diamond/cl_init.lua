/*---------------------------------------------------------------------------
Tomas
---------------------------------------------------------------------------*/
include("shared.lua")

surface.CreateFont( "SmallInfoFont", {
	font = "Arial",
	size = 12,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "InfoFont", {
	font = "Arial",
	size = 17,
	weight = 800,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "BigInfoFont", {
	font = "Arial",
	size = 32,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

surface.CreateFont( "BiggestInfoFont", {
	font = "Arial",
	size = 30,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )


function ENT:Initialize()
	self.Money = 0
	self.rot = 0
	self.last = SysTime()
	self.Speed = 20
	self.Heat = 0
	self.PlusMoney = 0
	self.LvlExp = 100
	self.PrintRate = 10
	self.NextPrint = CurTime()

	self.Cooler = false

	self.ComputerPartColor = Color(255, 255, 255, 255)
	self.FanCaseColor = Color(27, 27, 27, 255)
	self.FanColor = Color(166, 166, 166, 255)

	self.ComputerPartMaterial = "nomat"
	self.FanCaseMaterial = "models/debug/debugwhite"
	self.FanMaterial = "models/debug/debugwhite"

	if self.CrclCfg.ComputerPartColor then self.ComputerPartColor = self.CrclCfg.ComputerPartColor end
	if self.CrclCfg.FanCaseColor then self.FanCaseColor = self.CrclCfg.FanCaseColor end
	if self.CrclCfg.FanColor then self.FanColor = self.CrclCfg.FanColor end
	if self.CrclCfg.ComputerPartMaterial then self.ComputerPartMaterial = self.CrclCfg.ComputerPartMaterial end
	if self.CrclCfg.FanCaseMaterial then self.FanCaseMaterial = self.CrclCfg.FanCaseMaterial end
	if self.CrclCfg.FanMaterial then self.FanMaterial = self.CrclCfg.FanMaterial end


	self.CoreComputer = ents.CreateClientProp()
	self.CoreComputer:SetPos( self:GetPos() + self:GetAngles():Right() * 3.3 + self:GetAngles():Forward() * 10.6 + self:GetAngles():Up() * 3.7 )
	self.CoreComputer:SetModel( "models/props_lab/reciever01a.mdl" )
	self.CoreComputer:SetAngles(self:GetAngles())
	if self.ComputerPartMaterial != "nomat" then
		self.CoreComputer:SetMaterial( self.ComputerPartMaterial )
	end
	self.CoreComputer:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.CoreComputer:SetColor( self.ComputerPartColor )
	self.CoreComputer:SetParent( self )
	self.CoreComputer:Spawn()

	self.FanCase = ents.CreateClientProp()
	self.FanCase:SetPos( self:GetPos() + self:GetAngles():Right() * -11.8 + self:GetAngles():Forward() * 17 + self:GetAngles():Up() * 3.6 )
	self.FanCase:SetModel( "models/hunter/misc/platehole1x1a.mdl" )
	self.FanCase:SetModelScale( 0.155, 0)
	self.FanCase:SetAngles(self:GetAngles()+Angle(90, 0, 0))
	if self.FanCaseMaterial != "nomat" then
		self.FanCase:SetMaterial( self.FanCaseMaterial )
	end
	self.FanCase:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.FanCase:SetColor( self.FanCaseColor )
	self.FanCase:SetParent( self )
	self.FanCase:Spawn()

	self.FanBlades = ents.CreateClientProp()
	self.FanBlades:SetPos( self:GetPos() + self:GetAngles():Right() * -11.8 + self:GetAngles():Forward() * 17 + self:GetAngles():Up() * 3.6 )
	self.FanBlades:SetModel( "models/xqm/jetenginepropellermedium.mdl" )
	self.FanBlades:SetModelScale( 0.15, 0)
	self.FanBlades:SetAngles(self:GetAngles())
	if self.FanMaterial != "nomat" then
		self.FanBlades:SetMaterial( self.FanMaterial )
	end
	self.FanBlades:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.FanBlades:SetColor( self.FanColor )
	self.FanBlades:SetParent( self )
	self.FanBlades:Spawn()
end

function ENT:OnRemove()
	if IsValid(self.CoreComputer) then
		self.CoreComputer:Remove()
	end
	if IsValid(self.FanCase) then
		self.FanCase:Remove()
	end
	if IsValid(self.FanBlades) then
		self.FanBlades:Remove()
	end
end

local function drawCircle(x, y, ang, seg, p, rad, color)
	local cirle = {}

	table.insert( cirle, { x = x, y = y} )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -p + ang )
		table.insert( cirle, { x = x + math.sin( a ) * rad, y = y + math.cos( a ) * rad } )
	end
	surface.SetDrawColor( color )
	draw.NoTexture()
	surface.DrawPoly( cirle )
end

function ENT:Think()
	local Pos, Ang, Ang2 = self:GetPos(), self:GetAngles(), self:GetAngles()

	if IsValid(self.CoreComputer) then
		self.CoreComputer:SetPos( Pos + Ang:Right() * 3.45 + Ang:Forward() * 10.6 + Ang:Up() * 3.7 )
		self.CoreComputer:SetAngles(Ang2)
	end

	Ang2:RotateAroundAxis(Ang:Up(), 180)
	Ang2:RotateAroundAxis(Ang:Right(), 90)

	if IsValid(self.FanCase) then
		self.FanCase:SetPos( Pos + Ang:Right() * -11.8 + Ang:Forward() * 17 + Ang:Up() * 3.6 )
		self.FanCase:SetAngles(Ang2)
	end
end

function ENT:Draw()
	self:DrawModel()
	if self:GetPos():Distance( LocalPlayer():GetPos() ) > 1000 then return end

	if IsValid(self.FanBlades) then
			self.FanBlades:SetPos( self:GetPos() + self:GetAngles():Right() * -11.8 + self:GetAngles():Forward() * 17 + self:GetAngles():Up() * 3.6 )
			self.FanBlades:SetAngles(self:GetAngles()+Angle(0,0,self.rot))
		if self.Cooler == true then
			if ( self.rot > 359 ) then self.rot = 0 end

			self.rot = self.rot - ( 200*( self.last-SysTime() ) )
			self.last = SysTime()
			if IsValid(self.FanCase) then
				self.FanCase:SetColor(self.FanCaseColor)
			end
			if IsValid(self.FanBlades) then
				self.FanBlades:SetColor(self.FanColor)
			end
		else
			if IsValid(self.FanCase) then
				self.FanCase:SetColor(Color(255, 255, 255, 0))
			end
			if IsValid(self.FanBlades) then
				self.FanBlades:SetColor(Color(255, 255, 255, 0))
			end
		end
	end


	local Pos, Ang, pWidth = self:GetPos(), self:GetAngles(), 279

	local Owner = self:Getowning_ent()
	if IsValid(Owner) and Owner:Nick() then 
		Owner = Owner:Nick()
		if string.len(Owner) > 10 then
			Owner = string.Left( Owner, 10 ).."..."
		end
	else 
		Owner = "Unknown" 
	end


	Ang:RotateAroundAxis(Ang:Up(), 90)


	cam.Start3D2D(Pos + Ang:Up() * 10.70 + Ang:Forward() * -15.15 + Ang:Right() * -16.35, Ang, 0.11)
		surface.SetDrawColor(57, 66, 100)
		surface.DrawRect(0, 0, pWidth, 290)

		surface.SetDrawColor(80, 89, 123)
		surface.DrawRect(0, 0, pWidth, 50)

		surface.SetDrawColor(17, 168, 171)
		surface.DrawRect(0, 50, pWidth, 3)
		for i = 0, 3 do
			surface.SetDrawColor(80, 89, 123)
			surface.DrawRect(i*70, 225, 69, 65)
		end

		surface.SetDrawColor(230, 76, 101)
		surface.DrawRect(0, 222, 69, 3)

		surface.SetDrawColor(17, 168, 171)
		surface.DrawRect(70, 222, 69, 3)

		surface.SetDrawColor(252, 177, 80)
		surface.DrawRect(140, 222, 69, 3)

		surface.SetDrawColor(79, 196, 246)
		surface.DrawRect(210, 222, 69, 3)

		surface.SetDrawColor(57, 66, 100)
		surface.DrawRect(215, 244, 59, 15)

		surface.SetDrawColor(57, 66, 100)
		surface.DrawRect(215, 262, 59, 15)

		if self.Speed == 100 then
			surface.SetDrawColor(230, 76, 101)
		else
			surface.SetDrawColor(17, 168, 171)
		end
		surface.DrawRect(215, 244, 3, 15)

		if self.Cooler == true then
			surface.SetDrawColor(230, 76, 101)
		else
			surface.SetDrawColor(17, 168, 171)
		end
		surface.DrawRect(215, 262, 3, 15)

--***********
		drawCircle(pWidth/2, 137, 180, 40, 360, 80, Color(79, 196, 246))

		if CurTime() <= self.NextPrint then
			drawCircle(pWidth/2, 137, 180, 40, (self.NextPrint-CurTime())*360/self.PrintRate, 80, Color(230, 76, 101))
		end

		surface.SetDrawColor(57, 66, 100)
		drawCircle(pWidth/2, 137, 180, 40, 360, 60, Color(57, 66, 100))

		draw.DrawText( self.CrclCfg.Name, "BigInfoFont", pWidth/2, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		draw.DrawText( "Rate", "InfoFont", 34, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

		draw.DrawText("$"..self.PlusMoney/100*self.Speed + (math.floor(self.LvlExp/100)*self.PlusMoney/4), "BiggestInfoFont", 34, 242, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )

		draw.DrawText( "Heat", "InfoFont", 104, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

		draw.DrawText(self.Heat.."%", "BiggestInfoFont", 104, 242, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )

		draw.DrawText( "Speed", "InfoFont", 174, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

		draw.DrawText(self.Speed.."%", "BiggestInfoFont", 174, 242, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )

		draw.DrawText( "Upgrade", "InfoFont", 244, 225, Color( 131, 140, 171, 255 ), TEXT_ALIGN_CENTER )

		draw.DrawText( "Speed", "SmallInfoFont", 245, 245, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		draw.DrawText( "Cooler", "SmallInfoFont", 245, 263, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

		draw.DrawText( "MONEY", "BiggestInfoFont", pWidth/2, 110, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.DrawText( "$"..self.Money, "BigInfoFont", pWidth/2, 135, Color( 144, 153, 183, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()


	Ang:RotateAroundAxis(Ang:Forward(), 90)

	cam.Start3D2D(Pos + Ang:Up() * 16.20 + Ang:Forward() * -15 + Ang:Right() * -10.5, Ang, 0.11)
		surface.SetDrawColor(80, 89, 123)
		surface.DrawRect(0, 0, 210, 33.5)

		surface.SetDrawColor(230, 76, 101)
		surface.DrawRect(0, 31.5, 210, 3)

		draw.DrawText( Owner, "BigInfoFont", 105, 1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()

	cam.Start3D2D(Pos + Ang:Up() * 16.6 + Ang:Forward() * 8.6 + Ang:Right() * -9.4, Ang, 0.11)
		surface.SetDrawColor(80, 89, 123)
		surface.DrawRect(0, 0, 58, 20)

		surface.SetDrawColor(0, 0, 0, 150)
		surface.DrawRect(0, 0, tonumber(string.Right( self.LvlExp.."", 2 ),10)/100*58, 20)

		surface.SetDrawColor(230, 76, 101)
		surface.DrawRect(0, 18, 58, 3)

		draw.DrawText( "Level: "..math.floor(self.LvlExp/100), "InfoFont", 29, 1, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end


net.Receive( "UPCCS", function()
	local tabl = net.ReadTable()
	local ent = net.ReadEntity()
	ent.Money = tabl.Money
	ent.Speed = tabl.Speed
	ent.Heat = tabl.Heat
	ent.Cooler = tabl.Cooler
	ent.PlusMoney = tabl.PlusMoney
	ent.LvlExp = tabl.LvlExp
	ent.PrintRate = tabl.PrintRate
	ent.NextPrint = tabl.NextPrint
end )