SWEP.Author				= "Zephruz"
SWEP.Contact			= ""
SWEP.Purpose			= ""
SWEP.Instructions		= ""

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_toolgun.mdl"
SWEP.WorldModel			= "models/weapons/w_toolgun.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.instrTbl = {
    MGangs.Language:GetTranslation("territory_creator_info1"),
    MGangs.Language:GetTranslation("territory_creator_info2"),
    MGangs.Language:GetTranslation("territory_creator_info3")
}

-- Config
SWEP.CreateMenu = false
SWEP.BoxPoints = {false,false}
SWEP.Flag = {
  mdl = "models/zerochain/mgangs2/mgang_flagpost.mdl",
  pos = false,
}

SWEP.nextAttFixTime = CurTime() + 1
function SWEP:PrimaryAttack()
  if (CurTime() < self.nextAttFixTime) then return false end
  if (IsValid(self.CreateMenu)) then return false end
  self.nextAttFixTime = CurTime() + 1

	local tr = self.Owner:GetEyeTrace()

  if !(self.Flag.pos) then
    self.Flag.pos = (tr.HitPos)
  else
  	self.BoxPoints[1] = (self.BoxPoints[1] || tr.HitPos)
  end
end

function SWEP:SecondaryAttack()
  if (IsValid(self.CreateMenu)) then return false end
  if (!self.BoxPoints or !self.BoxPoints[1] or !self.BoxPoints[2] or !self.Flag.pos) then return false end

	local tr = self.Owner:GetEyeTrace()

  if (CLIENT) then
    self.CreateMenu = MG2_TERRITORIES:MenuEditTerritory({
      boxPos = self.BoxPoints,
      flag = {
        mdl = self.Flag.mdl,
        pos = self.Flag.pos,
      },
    },
    MGangs.Language:GetTranslation("create_territory"), -- Frame title
    function(data)      -- On Submit/Create
      MG2_TERRITORIES:CreateTerritory(data)
    end)
  end
end

function SWEP:Reload()
  local own = self.Owner

	self.BoxPoints = {false,false}
	self.Flag.pos = false
end

function SWEP:SetStatus(id)
	if !(self.Status[id]) then return false end

	self._statusid = (id or 1)
end

function SWEP:Think()
  if (IsValid(self.CreateMenu)) then return false end

  if !(self.Flag.pos) then
    self.instrTbl[1] = MGangs.Language:GetTranslation("territory_creator_info1_flag")
  else
    self.instrTbl[1] = MGangs.Language:GetTranslation("territory_creator_info1")
  end

	local own = self.Owner
	local tr = own:GetEyeTrace()

	if (IsValid(own)) then
		if (CLIENT && input.IsMouseDown(MOUSE_LEFT)) then
			self.BoxPoints[2] = WorldToLocal(tr.HitPos, Angle(0,0,0), self.BoxPoints[1] or tr.HitPos, Angle(0,0,0))
		end
	end
end
