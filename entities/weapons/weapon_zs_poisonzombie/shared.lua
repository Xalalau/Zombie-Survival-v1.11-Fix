SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModel = "models/weapons/v_pza.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

SWEP.ThrowAnimBaseTime = 2

function SWEP:Reload()
	return false
end

function SWEP:Precache()
	util.PrecacheSound("npc/zombie_poison/pz_throw2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_throw3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn1.wav")
	util.PrecacheSound("npc/zombie_poison/pz_warn2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle2.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle3.wav")
	util.PrecacheSound("npc/zombie_poison/pz_idle4.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump1.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump2.wav")
	util.PrecacheSound("npc/headcrab_poison/ph_jump3.wav")
end

function SWEP:GetThrowAnimTime()
	return self:GetDTFloat(0)
end