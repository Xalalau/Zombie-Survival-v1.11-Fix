SWEP.Author = "JetBoom"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

-- Support replacement weapons, so we don't require CSS - Xala
if file.Exists("models/weapons/2_knife_t.mdl", "GAME") then
	SWEP.ViewModel = "models/weapons/2_knife_t.mdl"
	SWEP.WorldModel = "models/weapons/3_knife_t.mdl"
else
	SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
	SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
end

SWEP.HoldType = "melee"

SWEP.Primary.ClipSize = -1
SWEP.Primary.Damage = 15
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 0.75

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.WalkSpeed = 215

function SWEP:Reload()
	return false
end

function SWEP:Precache()
	util.PrecacheSound("weapons/knife/knife_hit1.wav")
	util.PrecacheSound("weapons/knife/knife_hit2.wav")
	util.PrecacheSound("weapons/knife/knife_hit3.wav")
	util.PrecacheSound("weapons/knife/knife_hit4.wav")
	util.PrecacheSound("weapons/knife/knife_slash1.wav")
	util.PrecacheSound("weapons/knife/knife_slash2.wav")
	util.PrecacheSound("weapons/knife/knife_hitwall1.wav")
end
