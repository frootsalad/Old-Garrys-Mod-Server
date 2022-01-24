ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true

AddCSLuaFile()

function ENT:Initialize( )

	if SERVER then
		self:SetModel( "models/monk.mdl" )
		self:SetHullType( HULL_HUMAN )
		self:SetHullSizeNormal( )
		self:SetNPCState( NPC_STATE_SCRIPT )
		self:SetSolid(  SOLID_BBOX )
		self:CapabilitiesAdd( CAP_ANIMATEDFACE )
		self:CapabilitiesAdd( CAP_TURN_HEAD )
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()

		self:SetMaxYawSpeed( 90 )
	end

	local seq = self:LookupSequence("lineidle02")
	self:ResetSequence(seq)
	self:SetSequence(seq)

end

ENT.NextTP = 0
ENT.NextSequence = 0
function ENT:Think()
	if (self.NextTP == 0 and SERVER) then self.NextTP = CurTime() + math.random(120,240) * 5 end
	if (self.NextTP < CurTime() and SERVER) then
		self.NextTP = CurTime() + math.random(120,240) * 5
		if(self.Positions and #self.Positions > 0) then
			local pos = self.Positions[math.random(1,#self.Positions)]
			self:SetPos(pos[1])
			self:SetAngles(Angle(0, pos[2], 0))
		end
	end

	if self.NextSequence < CurTime() then
		local seq = self:LookupSequence("lineidle02")
		self:ResetSequence(seq)
		self:SetSequence(seq)
		self.NextSequence = CurTime() + self:SequenceDuration(seq)
	end
end

local a

if SERVER then
  util.AddNetworkString("CreateDealer")
  util.AddNetworkString("SendDealerInfo")
  util.AddNetworkString("CallDealer")
  util.AddNetworkString("DoDealerDeliver")
end


function ENT:AcceptInput( Name, Activator, Caller )
	if Name == "Use" and Caller:IsPlayer() then
		net.Start("CallDealer")
		net.Send(Caller)
	end
end

ENT.Notified = false

local lns = {"Psst...Boy, wanna some dank?",
"Do you look tired, wanna some fun?",
"Hey, wanna some drugs?",
"Come here, i have something for you",
"Are you a police? Nah, come here!"}
function ENT:GetPlayerColor()
  if(!self.Notified) then
    if(LocalPlayer():GetPos():Distance(self:GetPos()) < 1024)  then
      self.TR = util.TraceLine( {
	      start = self:EyePos(),
      endpos = LocalPlayer():EyePos() + (self:EyePos()-LocalPlayer():EyePos())*-0.4,
	     filter = self
     } )
      if(self.TR.Entity == LocalPlayer()) then
        chat.AddText(Color(155, 89, 182),"[DEALER] ",Color(235,235,235),lns[math.random(1,#lns)])
        self.Notified = true
        self.TR = nil
      end
    end
  end
	return Vector(1,0.2,1)
end

concommand.Add("create_dealer",function(ply)
	if(ply:IsAdmin() and CLIENT) then
		net.Start("CreateDealer")
		net.SendToServer()
	else
		local tbl = {}
		if(file.Exists(game.GetMap().."_dealers.txt","DATA")) then
			tbl = util.JSONToTable(file.Read(game.GetMap().."_dealers.txt","DATA"))
		end
		table.insert(tbl,{ply:GetPos(),ply:GetAngles().y})
		file.Write(game.GetMap().."_dealers.txt",util.TableToJSON(tbl,true))
    	DarkRP.notify(ply, 3, 3, "Dealer created, check console for instructions!")
    	net.Start("SendDealerInfo")
    	net.Send(ply)
	end
end)

net.Receive("CreateDealer",function(l,ply)
	if(ply:IsAdmin()) then
		local tbl = {}
		if(file.Exists(game.GetMap().."_dealers.txt","DATA")) then
			tbl = util.JSONToTable(file.Read(game.GetMap().."_dealers.txt","DATA"))
		end
		table.insert(tbl,{ply:GetPos(),ply:GetAngles().y})
		file.Write(game.GetMap().."_dealers.txt",util.TableToJSON(tbl,true))
    	DarkRP.notify(ply, 3, 3, "Dealer created, check console for instructions!")
    	net.Start("SendDealerInfo")
    	net.Send(ply)
	end
end)

net.Receive("SendDealerInfo",function()
  MsgN("Copy data/"..(game.GetMap().."_dealers.txt").." file into your server once you placed all dealers!")
end)

hook.Add("InitPostEntity","CreateQuests",function()

	if CLIENT then return end

	_weedDebug("Initialize ran from the server, this is good")

	local tbl = {}
	if(file.Exists(game.GetMap().."_dealers.txt","DATA")) then
		tbl = util.JSONToTable(file.Read(game.GetMap().."_dealers.txt","DATA"))
	end
	_weedDebug("We got the table, we have "..#tbl.." dealers in the map")
	local iniPos = tbl[math.random(1,#tbl)]
	local ent = ents.Create("npc_drug_dealer")
	ent:SetPos(iniPos[1])
	ent:SetAngles(Angle(0,iniPos[2],0))
	ent:Spawn()
	ent.Positions = tbl

end)

net.Receive("DoDealerDeliver",function(l,ply)
	local b = net.ReadBool()

	if((!b && ply:HasWeapon("sent_tablet")) || (b && ply:HasWeapon("sent_bong"))) then
		DarkRP.notify(ply, 1, 3, "You already got this item!")
		return
	end

	if(!b && ply:getDarkRPVar("money")>=WEED_CONFIG.TabletPrice) then
		DarkRP.notify(ply, 3, 3, "You bought a provider's tablet at $"..(WEED_CONFIG.TabletPrice or 0))
		ply:addMoney(-WEED_CONFIG.TabletPrice)
		ply:Give("sent_tablet")
	end

	if(b && ply:getDarkRPVar("money")>=WEED_ITEMS.Items["Tools"]["bong"].price) then
		DarkRP.notify(ply, 3, 3, "You bought a bong at $"..(WEED_ITEMS.Items["Tools"]["bong"].price or 0))
		ply:addMoney(-WEED_ITEMS.Items["Tools"]["bong"].price)
		ply:Give("sent_bong")
	end
end)

if CLIENT then

local pnl

surface.CreateFont("Trebuchet24", {
	font = "Trebuchet MS",
	size = 24,
	weight = 900
})

local rpl = {"Go away kid, I'm trying to work",
"What do you need, i'm bussy narc",
"I'm not doing nothing illegal, can you go away?",
"I'll call the REAL police if you don't go away",
"Move the FUCK UP!"}

net.Receive("CallDealer",function(l,ply)
	local a,b = table.Random(rpl)
  	if(!WEED_CONFIG:CanDeal(LocalPlayer())) then
    	chat.AddText(Color(155, 89, 182),"[DEALER] ",Color(235,235,235),a)
    	return
  	end

	if(pnl != nil) then
		pnl:Remove()
		pnl = nil
	end
	pnl = vgui.Create("gDealer")
	pnl:MakePopup()

end)

end
