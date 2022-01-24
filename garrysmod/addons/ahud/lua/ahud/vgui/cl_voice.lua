local PANEL = {}
local PlayerVoicePanels = {}

function PANEL:Init()
	self.LabelName = vgui.Create("DLabel", self)
	self.LabelName:SetFont("aHUD24")
	self.LabelName:Dock(FILL)
	self.LabelName:DockMargin(4, 0, 0, 18)
	self.LabelName:SetTextColor(aHUD.Color)

	self.Avatar = vgui.Create("AvatarCircleMask", self)
	self.Avatar:Dock(LEFT)
	self.Avatar:SetSize(36, 36)
    self.Avatar:SetMaskSize(36 / 2) 

	self.Color = Color(41, 41, 41)

	self.BarWidth = 0

	self:SetSize(250, 44 + 8)
	self:DockPadding(4, 6, 4, 4)
	self:DockMargin(2, 2, 2, 2)
	self:Dock(BOTTOM)
end

function PANEL:Setup(ply)
	self.ply = ply
	self.LabelName:SetText(ply:Nick())
	self.Avatar:SetPlayer(self.ply, 32)
	
	self.Color = team.GetColor(ply:Team())
	
	self:InvalidateLayout()
end

function PANEL:Paint(w, h)
	if (!IsValid(self.ply)) then return end
	draw.RoundedBox(0, 0, 0, w, h, Color(41, 41, 41, 255))
	draw.RoundedBox(4, 2, 6, w-4, h-8, Color(61, 61, 61, 255))
	draw.RoundedBox(0, 0, 0, w, 4, aHUD.Color)

	if self.ply == LocalPlayer() then
		draw.RoundedBox(2, 44, h/2+5, self:GetWide() - 50, 2, aHUD.Color)
	else
		draw.RoundedBox(0, 44, h/2+6, self:GetWide() - 51, 10, Color(41, 41, 41))
		draw.RoundedBox(0, 46, h/2+8, math.Clamp(self.BarWidth*2.5, 0, (self:GetWide() - 55)), 6, aHUD.Color)		
	end
end

function PANEL:Think()
	if (IsValid(self.ply)) then
		self.LabelName:SetText(self.ply:Nick())
	    if self.BarWidth != (self:GetWide() - 55)*self.ply:VoiceVolume() then
	        self.BarWidth = Lerp(8 * FrameTime(), self.BarWidth, (self:GetWide() - 55)*self.ply:VoiceVolume())
	    end	
	end

	if (self.fadeAnim) then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut(anim, delta, data)
	if (anim.Finished) then
	
		if (IsValid(PlayerVoicePanels[ self.ply ])) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
		
	return end
	
	self:SetAlpha(255 - (255 * delta))
end

derma.DefineControl("VoiceNotify", "", PANEL, "DPanel")
timer.Simple(1, function() derma.DefineControl("VoiceNotify", "", PANEL, "DPanel")  end)

local function VoiceClean()
	for k, v in pairs(PlayerVoicePanels) do
		if (!IsValid(k)) then
			GAMEMODE:PlayerEndVoice(k)
		end
	end
end
timer.Create("aVoiceClean", 10, 0, VoiceClean)

hook.Add("PostGamemodeLoaded", "aVoiceLoad", function()
	function GAMEMODE:PlayerStartVoice(ply)
		if (!IsValid(g_VoicePanelList)) then return end

		if ply == LocalPlayer() then
	        ply.DRPIsTalking = true
	        return -- Not the original rectangle for yourself! ugh!
	    end

		GAMEMODE:PlayerEndVoice(ply)

		if (IsValid(PlayerVoicePanels[ ply ])) then

			if (PlayerVoicePanels[ ply ].fadeAnim) then
				PlayerVoicePanels[ ply ].fadeAnim:Stop()
				PlayerVoicePanels[ ply ].fadeAnim = nil
			end

			PlayerVoicePanels[ ply ]:SetAlpha(255)

			return
		end

		if (!IsValid(ply)) then return end

		local pnl = g_VoicePanelList:Add("VoiceNotify")
		pnl:Setup(ply)
		
		PlayerVoicePanels[ ply ] = pnl		
	end

	function GAMEMODE:PlayerEndVoice(ply)

	    if ply == LocalPlayer() then
	        ply.DRPIsTalking = false
	        return
	    end

		if (IsValid(PlayerVoicePanels[ ply ])) then

			if (PlayerVoicePanels[ ply ].fadeAnim) then return end

			PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim("FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut)
			PlayerVoicePanels[ ply ].fadeAnim:Start(2)

		end
	end
end)