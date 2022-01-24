/*---------------------------------------------------------------------------
HUD ConVars
---------------------------------------------------------------------------*/
local HUDWidth = 300
local HUDHeight = 115
local Color = Color
local CurTime = CurTime
local cvars = cvars
local draw = draw
local GetConVar = GetConVar
local hook = hook
local IsValid = IsValid
local Lerp = Lerp
local LocalPlayer = LocalPlayer
local math = math
local pairs = pairs
local ScrW, ScrH = ScrW, ScrH
local SortedPairs = SortedPairs
local string = string
local surface = surface
local table = table
local timer = timer
local tostring = tostring
local plyMeta = FindMetaTable("Player")

surface.CreateFont("aHUD28", {font = "Open Sans",    size = 28,     weight = 500})
surface.CreateFont("aHUD26", {font = "Open Sans",    size = 26,     weight = 500})
surface.CreateFont("aHUD24", {font = "Open Sans",    size = 24,     weight = 500})
surface.CreateFont("aHUD22", {font = "Open Sans",    size = 22,     weight = 500})
surface.CreateFont("aHUD20", {font = "Open Sans",    size = 20,     weight = 500})
surface.CreateFont("aHUD16", {font = "Open Sans",    size = 15,     weight = 500})

include("ahud_config.lua")

include("vgui/cl_circleavatar.lua")
if aHUD.CustomNotifications then
    include("vgui/cl_notification.lua")
end

if aHUD.CustomVoicepanels then
    include("vgui/cl_voice.lua")
end

aHUD.Cur = aHUD.Cur or {}

aHUD.Cur.Health  = nil
aHUD.Cur.Wallet  = nil
aHUD.Cur.Salary  = nil
aHUD.Cur.Job     = nil

aHUD.Cur.Agenda  = nil

aHUD.GetLongestTextLength = function(strings, font)
    local longest = 0

    surface.SetFont(font)
    for k, v in pairs(strings) do
        local w, h = surface.GetTextSize(v)
        if w > longest then
            longest = w
        end
    end
    return longest
end

aHUD.Arrested = function() end
usermessage.Hook("GotArrested", function(msg)
    local StartArrested = CurTime()
    local ArrestedUntil = msg:ReadFloat()

    Arrested = function()
        if CurTime() - StartArrested <= ArrestedUntil and LocalPlayer():getDarkRPVar("Arrested") then
        draw.RoundedBox(4, Scrw / 2 - 175, Scrh - Scrh / 12, 350, 32, Color(62, 62, 62, 255))
        draw.RoundedBox(2, Scrw / 2 - 175, Scrh - Scrh / 12, 350, 2, Color(215, 85, 80))
        draw.SimpleText(DarkRP.getPhrase("youre_arrested", math.ceil(ArrestedUntil - (CurTime() - StartArrested))), "aHUD24", Scrw / 2, Scrh - Scrh / 12 + 4, Color(230, 230, 230, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        elseif not LocalPlayer():getDarkRPVar("Arrested") then
            Arrested = function() end
        end
    end
end)

aHUD.AdminTell = function() end
usermessage.Hook("AdminTell", function(msg)
    timer.Remove("DarkRP_AdminTell")
    local Message = msg:ReadString()

    AdminTell = function()
        draw.RoundedBox(4, 10, 10, Scrw - 20, 110, colors.darkblack)
        draw.DrawNonParsedText(DarkRP.getPhrase("listen_up"), "GModToolName", Scrw / 2 + 10, 10, colors.white, 1)
        draw.DrawNonParsedText(Message, "ChatFont", Scrw / 2 + 10, 90, colors.brightred, 1)
    end

    timer.Create("DarkRP_AdminTell", 10, 1, function()
        AdminTell = function() end
    end)
end)

hook.Add("InitPostEntity", "aHUDInit", function()

    MsgC(Color(66, 139, 202), "[aHUD] ", Color(210, 210, 210), "Loaded aHUD by ", Color(66, 139, 202) ,"arie ", Color(210, 210, 210),"(STEAM_0:0:22593800)\n")

    hook.Add("Think", "aHUDThink", function()
        if aHUD.Cur and aHUD.Cur.Health then
            if aHUD.Cur.Health != LocalPlayer():Health() then
                aHUD.Cur.Health = Lerp(7 * FrameTime(), aHUD.Cur.Health, LocalPlayer():Health() or 0)
            end

            if aHUD.Cur.Wallet != LocalPlayer():getDarkRPVar("money") then
                aHUD.Cur.Wallet = Lerp(7 * FrameTime(), aHUD.Cur.Wallet, LocalPlayer():getDarkRPVar("money") or 0)
            end

            if aHUD.Cur.Salary != LocalPlayer():getDarkRPVar("salary") then
                aHUD.Cur.Salary = Lerp(7 * FrameTime(), aHUD.Cur.Salary, LocalPlayer():getDarkRPVar("salary") or 0)
            end

            if aHUD.Cur.Job != LocalPlayer():getDarkRPVar("job") then
                aHUD.Cur.Job = LocalPlayer():getDarkRPVar("job")
            end

            if aHUD.Cur.Agenda != LocalPlayer():getDarkRPVar("agenda") then
                aHUD.Cur.Agenda = LocalPlayer():getDarkRPVar("agenda") or ""
            end
        end
    end)
end)

local Scrw, Scrh, RelativeX
local Page = Material("icon16/page_white_text.png")

hook.Add("InitPostEntity", "aHUDInitPostEntity", function()
    aHUD.Model = vgui.Create("AvatarCircleMask")
    aHUD.Model:ParentToHUD()
    aHUD.Model:SetSize(64, 64)
    aHUD.Model:SetPos(16, ScrH() - HUDHeight + 17)
    aHUD.Model:SetPlayer(LocalPlayer(), 64)
    aHUD.Model:SetMaskSize(64 / 2)
end)

local agendaText
aHUD.DarkRPFuncs = function()
    local chbxX, chboxY = chat.GetChatBoxPos()
    if GetGlobalBool("DarkRP_LockDown") then
        local cin = (math.sin(CurTime()) + 1) / 2
        local chatBoxSize = math.floor(Scrh / 4)
        draw.SimpleText(DarkRP.getPhrase("lockdown_started"), "aHUD24",chbxX, chboxY + chatBoxSize, Color(230, cin * 230,cin *  230, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    end

    local agenda = LocalPlayer():getAgendaTable()
    if not agenda then return end

    agendaText = DarkRP.textWrap((LocalPlayer():getDarkRPVar("agenda") or ""):gsub("//", "\n"):gsub("\\n", "\n"), "aHUD20", 440)

    draw.RoundedBox(4, 10, 10, 460, 130, Color(62, 62, 62, 255))
    draw.RoundedBox(4, 10, 10, 460, 4, aHUD.Color)
    draw.RoundedBox(0, 10, 14, 460, 18, aHUD.Color)

    draw.SimpleText(agenda.Title, "aHUD22", 20, 9, Color(230, 230, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

    draw.DrawText(agendaText, "aHUD20", 20, 35, Color(230, 230, 230), TEXT_ALIGN_LEFT)
end

local function DrawHUD()
    Scrw, Scrh = ScrW(), ScrH()
    RelativeX, RelativeY = 5, Scrh

    aHUD.Cur.Health  = aHUD.Cur.Health or LocalPlayer():Health()
    aHUD.Cur.Wallet  = aHUD.Cur.Wallet or LocalPlayer():getDarkRPVar("money")
    aHUD.Cur.Salary  = aHUD.Cur.Salary or LocalPlayer():getDarkRPVar("salary")
    aHUD.Cur.Job     = aHUD.Cur.Job or LocalPlayer():getDarkRPVar("job")
    aHUD.Cur.Agenda  = aHUD.Cur.Agenda or LocalPlayer():getDarkRPVar("agenda") or ""

    local expand = aHUD.GetLongestTextLength({LocalPlayer():Name()}, "aHUD28")

    HUDWidth = math.max(300, expand + 95)

    draw.RoundedBox(0, 10, Scrh - HUDHeight - 6, HUDWidth, HUDHeight, Color(41, 41, 41, 255))
    draw.RoundedBox(4, 13, Scrh - HUDHeight + 13 , HUDWidth - 6, HUDHeight-22, Color(62, 62, 62, 255))
    draw.RoundedBox(2, 88, Scrh - HUDHeight + 38, HUDWidth - 87, 2, aHUD.Color)
    draw.RoundedBox(0, 10, Scrh - HUDHeight - 10, HUDWidth, 20, aHUD.Color)

    draw.RoundedBox(2, RelativeX + 12, Scrh - HUDHeight + 85, HUDWidth - 14, 10, Color(45, 45, 45, 255))
    draw.RoundedBox(2, RelativeX + 12, Scrh - HUDHeight + 85, math.Clamp(aHUD.Cur.Health, 2, 100) / 100 * (HUDWidth-14), 10, aHUD.Color)
    if aHUD.ShowHealth then
        draw.SimpleText(math.Round(aHUD.Cur.Health), "aHUD16", RelativeX + 12 + (HUDWidth - 14) / 2, Scrh - HUDHeight + 89, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    draw.RoundedBox(2, RelativeX + 12, Scrh - HUDHeight + 98, HUDWidth - 14, 5, Color(45, 45, 45, 255))
    if LocalPlayer():Armor() and LocalPlayer():Armor() > 2 then
        draw.RoundedBox(2, RelativeX + 12, Scrh - HUDHeight + 98, math.Clamp(LocalPlayer():Armor() or 0, 0, 100) / 100 * (HUDWidth-14), 5, aHUD.ArmorBarColor)
    end

    if not DarkRP.disabledDefaults["modules"]["hungermod"] then
        HUDHeight = 123
        aHUD.Model:SetPos(16, ScrH() - HUDHeight + 15)
        if LocalPlayer():getDarkRPVar("Energy") and LocalPlayer():getDarkRPVar("Energy") > 2 then
            draw.RoundedBox(2, RelativeX + 12, Scrh - HUDHeight + 106, HUDWidth - 14, 5, Color(45, 45, 45, 255))
            draw.RoundedBox(2, RelativeX + 12, Scrh - HUDHeight + 106, math.Clamp(LocalPlayer():getDarkRPVar("Energy") or 0, 0, 100) / 100 * (HUDWidth-14), 5, aHUD.HungerBarColor)
        end
    end

    draw.SimpleText(LocalPlayer():Name(), "aHUD28", 90, Scrh - HUDHeight + 12, aHUD.Color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(aHUD.Cur.Job, "aHUD24", 90, Scrh - HUDHeight + 39, Color(200, 200, 200), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(DarkRP.formatMoney(math.Round(aHUD.Cur.Wallet or LocalPlayer():getDarkRPVar("money"))), "aHUD22", 90, Scrh - HUDHeight + 61, Color(140, 140, 140), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText(DarkRP.formatMoney(math.Round(aHUD.Cur.Salary or LocalPlayer():getDarkRPVar("salary"))), "aHUD22", HUDWidth -1, Scrh - HUDHeight + 61, Color(140, 140, 140), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

    if IsValid(LocalPlayer():GetActiveWeapon()) then
        local mag_extra = LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType())
        local ammo = math.max(LocalPlayer():GetActiveWeapon():Clip1(), 0) .. " / " .. mag_extra

        if ammo != "0 / 0" then

            draw.RoundedBox(0, Scrw - 110, Scrh - 50, 100, 40, Color(41, 41, 41, 255))
            draw.RoundedBox(2, Scrw - 110, Scrh - 50, 100, 10, aHUD.Color)
            draw.RoundedBox(4, Scrw - 108, Scrh - 38 , 96, 26, Color(62, 62, 62, 255))

            draw.SimpleText(ammo, "aHUD28", (Scrw - 110) + 100 / 2, Scrh - 40, Color(190, 190, 190), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        end
    end

    aHUD.DarkRPFuncs()

    aHUD.Arrested()
    aHUD.AdminTell()
end


plyMeta.drawPlayerInfo = function(self)
    if not IsValid(self) then return end

    local pos = self:EyePos()
    pos.z = pos.z + 10
    pos = pos:ToScreen()

    if not self:getDarkRPVar("wanted") then
        pos.y = pos.y - 50
    end

    local strings = {self:Nick(), RPExtraTeams[self:Team()].name or "Unknown", self:Health(), self:getDarkRPVar("job") or team.GetName(self:Team())}
    self.aHUDwidth = math.max(aHUD.GetLongestTextLength(strings, "aHUD22"), 100) + 52
    self.aHUDcolour = Color(RPExtraTeams[self:Team()].color.r, RPExtraTeams[self:Team()].color.g, RPExtraTeams[self:Team()].color.b)

    if not self.HUDPanel then

        self.HUDPanel = vgui.Create("DPanel")
        self.HUDPanel:ParentToHUD()

        self.HUDPanel.Paint = function(this, w, h)
             if not IsValid(self) then
                this:Remove()
                --self.HUDPanel = nil
                return
            end

            local data = {
                text = self:Nick(),
                pos = {46, 10},
                font = "aHUD22",
                xalign = TEXT_ALIGN_LEFT,
                yalign = TEXT_ALIGN_TOP,
                color = color_black
            }

            draw.TextShadow(data, 1, 230)
            draw.SimpleText(self:Nick(), "aHUD22", 46, 10, self.aHUDcolour, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

            if GAMEMODE.Config.showhealth then
                draw.RoundedBox(0, 45, 31, math.Clamp(self:Health(), 0, 100) / 100 * (w - 50), 2, self.aHUDcolour)
            end

            if GAMEMODE.Config.showjob then
                data = {
                    text = self:getDarkRPVar("job") or team.GetName(self:Team()),
                    pos = {46, 32},
                    font = "aHUD22",
                    xalign = TEXT_ALIGN_LEFT,
                    yalign = TEXT_ALIGN_TOP,
                    color = color_black
                }
                draw.TextShadow(data, 1, 230)
                draw.SimpleText(self:getDarkRPVar("job") or team.GetName(self:Team()), "aHUD22", 46, 32, Color(170, 170, 170), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end
        end

        self.HUDPanel.HUDAvatar = vgui.Create("AvatarCircleMask", self.HUDPanel)
        self.HUDPanel.HUDAvatar:SetPlayer(self, 32)
        self.HUDPanel.HUDAvatar:SetSize(38, 38)
        self.HUDPanel.HUDAvatar:SetPos(4, 13)
        self.HUDPanel.HUDAvatar:SetMaskSize(38 / 2)
    end

    self.HUDPanel:SetSize(self.aHUDwidth, 56)
    self.HUDPanel:SetPos(pos.x - self.aHUDwidth / 2, pos.y)

    if self:getDarkRPVar("HasGunlicense") then
        surface.SetMaterial(Page)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawTexturedRect(pos.x-16, pos.y - 36, 32, 32)
    end
end

plyMeta.drawWantedInfo = function(self)

    if not self:Alive() then return end

    local pos = self:EyePos()
    if not pos:isInSight({LocalPlayer(), self}) then return end

    pos.z = pos.z + 10
    pos = pos:ToScreen()

    local nick, plyTeam = self:Nick(), self:Team()
    local data = {
        text = nick,
        pos = {pos.x, pos.y},
        font = "aHUD22",
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
        color = color_black
    }
    draw.TextShadow(data, 1, 200)
    draw.SimpleText(nick, "aHUD22", pos.x, pos.y, RPExtraTeams[plyTeam] and RPExtraTeams[plyTeam].color or team.GetColor(plyTeam), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    local wantedText = DarkRP.getPhrase("wanted", tostring(self:getDarkRPVar("wantedReason")))
    data = {
        text = wantedText,
        pos = {pos.x - 25, pos.y - 20},
        font = "aHUD22",
        xalign = TEXT_ALIGN_CENTER,
        yalign = TEXT_ALIGN_CENTER,
        color = color_black
    }
    draw.TextShadow(data, 1, 200)
    draw.SimpleText(wantedText, "aHUD22", pos.x - 25, pos.y - 20, Color(215, 85, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

local function DrawEntityDisplay()
    local shootPos = LocalPlayer():GetShootPos()
    local aimVec = LocalPlayer():GetAimVector()


    for k, ply in pairs(players or player.GetAll()) do
        if ply == LocalPlayer() or not ply:Alive() or ply:GetNoDraw() then
            if ply.HUDPanel then
                ply.HUDPanel:Remove()
                ply.HUDPanel = nil
            end
            continue
        end
        local hisPos = ply:GetShootPos()
        if ply:getDarkRPVar("wanted") then
            if ply.HUDPanel then
                ply.HUDPanel:Remove()
                ply.HUDPanel = nil
            end
            ply:drawWantedInfo()
            continue
        end

        if GAMEMODE.Config.globalshow then
            ply:drawPlayerInfo()
        elseif hisPos:DistToSqr(shootPos) < 160000 then
            local pos = hisPos - shootPos
            local unitPos = pos:GetNormalized()
            if unitPos:Dot(aimVec) > 0.95 then
                local trace = util.QuickTrace(shootPos, pos, LocalPlayer())
                if trace.Hit and trace.Entity != ply then
                    if ply.HUDPanel then
                        ply.HUDPanel:Remove()
                        ply.HUDPanel = nil
                    end
                    break
                end
                ply:drawPlayerInfo()
            else
                if ply.HUDPanel then
                    ply.HUDPanel:Remove()
                    ply.HUDPanel = nil
                end
            end
        else
            if ply.HUDPanel then
                ply.HUDPanel:Remove()
                ply.HUDPanel = nil
            end
        end
    end

    local tr = LocalPlayer():GetEyeTrace()

    if IsValid(tr.Entity) and tr.Entity:isKeysOwnable() and tr.Entity:GetPos():DistToSqr(LocalPlayer():GetPos()) < 40000 then
        tr.Entity:drawOwnableInfo()
    end
end

local function DisplayNotify(msg)
    local txt = msg:ReadString()
    GAMEMODE:AddNotify(txt, msg:ReadShort(), msg:ReadLong())
    surface.PlaySound("buttons/lightswitch2.wav")

    MsgC(Color(255, 20, 20, 255), "[DarkRP] ", Color(200, 200, 200, 255), txt, "\n")
end
usermessage.Hook("_Notify", DisplayNotify)

hook.Add("HUDPaint", "aHUDPaint", function()
    if not IsValid(LocalPlayer()) then return end

    if (not aHUD.Cur.Health) or (not aHUD.Cur.Wallet) or (not aHUD.Cur.Salary) or (not aHUD.Cur.Job) or (not aHUD.Cur.Job) then
        aHUD.Cur.Health  = LocalPlayer():Health()
        aHUD.Cur.Wallet  = LocalPlayer():getDarkRPVar("money")
        aHUD.Cur.Salary  = LocalPlayer():getDarkRPVar("salary")
        aHUD.Cur.Job     = LocalPlayer():getDarkRPVar("job")
        aHUD.Cur.Agenda  = LocalPlayer():getDarkRPVar("agenda") or ""
    end

    if not aHUD.Model:IsVisible() then
        aHUD.Model:Show()
    end

    DrawHUD()
    DrawEntityDisplay()
end)

for k, ply in pairs(player.GetAll()) do
    if ply.HUDPanel then
        ply.HUDPanel:Remove()
        ply.HUDPanel = nil
    end
end

hook.Add("Think", "aHUDModelHandle", function()
    if aHUD.Model and (IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_camera") then
        aHUD.Model:Hide()
    end
end)

local hideHUDElements = {
    ["DarkRP_HUD"]              = true,
    ["DarkRP_EntityDisplay"]    = true,
    ["DarkRP_LocalPlayerHUD"]   = true,
    ["DarkRP_Hungermod"]        = true,
    ["DarkRP_Agenda"]           = true,
    CHudHealth                  = true,
    CHudAmmo                    = true
}

hook.Add("HUDShouldDraw", "aHUDHideHUD", function(name)
    if hideHUDElements[name] then return false end
end)

concommand.Add("aHUD_TestNotifications", function()
    notification.AddLegacy("Testing generic notification", 0, 10)
    notification.AddLegacy("Testing error notification", 1, 10)
    notification.AddLegacy("Testing undo notification", 2, 10)
    notification.AddLegacy("Testing hint notification", 3, 10)
    notification.AddLegacy("Testing cleanup notification", 4, 10)
end)