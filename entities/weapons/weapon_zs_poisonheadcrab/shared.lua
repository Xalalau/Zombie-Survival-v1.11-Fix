SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.4

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Delay = 0.22
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.SpitWindUp = 1.25
SWEP.PounceWindUp = 1.25

function SWEP:Reload()
	return false
end

function SWEP:Precache()
	util.PrecacheSound("npc/headcrab_poison/ph_scream1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_scream2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_scream3.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_poisonbite1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_poisonbite2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_poisonbite3.wav")
end

function SWEP:GetNextSpit()
	return self:GetDTFloat(0)
end

function SWEP:IsGoingToSpit()
	return self:GetNextSpit() > 0
end

function SWEP:GetLeaping()
	return self:GetDTBool(0)
end
SWEP.IsLeaping = SWEP.GetLeaping

function SWEP:GetNextLeap()
	return self:GetDTFloat(1)
end

function SWEP:IsGoingToLeap()
	return self:GetNextLeap() > 0
end

function SWEP:ShouldPlayLeapAnimation()
	return self:IsLeaping() or self:IsGoingToLeap()
end