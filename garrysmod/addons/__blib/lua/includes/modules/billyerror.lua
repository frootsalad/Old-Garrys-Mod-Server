--[[

	LICENSE

	https://creativecommons.org/licenses/by-nc-nd/4.0/

	Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)

]]

--////////////////////////////////////////////////////////////////////////--

AddCSLuaFile()

if (SERVER) then
	BillyError_QueueTable = {}
	net.Receive("billyerror_ready",function(l,p)
		if (p:IsAdmin() or p:IsSuperAdmin()) then
			for i,v in pairs(BillyError_QueueTable) do
				net.Start("billyerror_senderror")
					net.WriteString(v[1])
					net.WriteString(v[2])
				net.Send(p)
				table.remove(BillyError_QueueTable,i)
			end
		end
	end)
end
local function setup()
	BillyError_Errors = {}
	if (SERVER) then
		util.AddNetworkString("billyerror_senderror")
		util.AddNetworkString("billyerror_ready")
	end
	function BillyError(context,err)
		MsgC(Color(255,0,0),"[BillyError ",Color(0,255,255),context,Color(255,0,0),"] ",Color(255,255,255),err .. "\n")
		if (CLIENT) then
			if (BillyError_Errors[context] == nil) then
				BillyError_Errors[context] = {}
			end
			table.insert(BillyError_Errors[context],err)
			BillyError_OpenMenu()
		else
			net.Start("billyerror_senderror")
				net.WriteString(context)
				net.WriteString(err)
			if (#player.GetAll() > 0) then
				local f = false
				for _,v in pairs(player.GetAll()) do
					if (v:IsSuperAdmin() or v:IsAdmin()) then
						f = true
						net.Send(v)
					end
				end
				if (not f) then
					table.insert(BillyError_QueueTable,{context,err})
				end
			else
				table.insert(BillyError_QueueTable,{context,err})
			end
		end
	end
end
if (not BillyError) then
	setup()
end

if (CLIENT) then
	function BillyError_OpenMenu()
		if (IsValid(BillyError_Menu)) then
			BillyError_Menu.categories:Update()
			return
		end
		timer.Stop("billyerror_openmenu")
		timer.Create("billyerror_openmenu",1,0,function()
			BillyError_Menu = vgui.Create("BFrame")
			if (IsValid(BillyError_Menu)) then
				timer.Stop("billyerror_openmenu")

				local m = BillyError_Menu
				m:SetTitle("BillyError")
				m:SetSize(450,300)
				m:Center()
				m:Configured()
				m:MakePopup()

				m.bg = vgui.Create("DPanel",m)
				m.bg:SetSize(300,276)
				m.bg:AlignRight()
				m.bg:AlignBottom()
				m.bg.Paint = function(self)
					surface.SetDrawColor(Color(5,5,35))
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				end

				m.textbox = vgui.Create("BLabel",m)
				m.textbox:SetText("You're seeing this because something has encountered an error. Click the items on the left to find out why. You'll see the script that is experiencing issues at the top of the list.")
				m.textbox:White()
				m.textbox:SetSize(290,266)
				m.textbox:AlignRight(5)
				m.textbox:AlignBottom(5)
				m.textbox:SetWrap(true)
				m.textbox:SetContentAlignment(7)

				m.categories = vgui.Create("BCategories",m)
				m.categories:SetSize(150,276)
				m.categories:AlignBottom()
				function m.categories:Update()
					m.categories:Clear()
					for context,errs in pairs(BillyError_Errors) do
						local c = ColorRand()
						m.categories:NewCategory(context,c)
						for i,err in pairs(errs) do
							m.categories:NewItem(i,c,function()
								m.textbox:SetText(BillyError_Errors[context][i])
							end,true)
						end
					end
				end
				m.categories:Update()
			end
		end)
	end
	net.Receive("billyerror_senderror",function()
		local context = net.ReadString()
		local err     = net.ReadString()
		if (BillyError_Errors[context] == nil) then
			BillyError_Errors[context] = {}
		end
		table.insert(BillyError_Errors[context],err)
		BillyError_OpenMenu()
	end)
	hook.Add("InitPostEntity","billyerror_ready",function()
		net.Start("billyerror_ready")
		net.SendToServer()
	end)
end

