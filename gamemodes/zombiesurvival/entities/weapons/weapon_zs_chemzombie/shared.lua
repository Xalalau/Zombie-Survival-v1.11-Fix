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
SWEP.Primary.Delay = 2

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo	= "none"

function SWEP:Reload()
	return false
end

function SWEP:Precache()
	util.PrecacheSound("npc/metropolice/pain1.wav")
	util.PrecacheSound("npc/metropolice/pain2.wav")
	util.PrecacheSound("npc/metropolice/pain3.wav")
	util.PrecacheSound("npc/metropolice/pain4.wav")
	util.PrecacheSound("npc/metropolice/knockout2.wav")
	util.PrecacheSound("ambient/fire/gascan_ignite1.wav")
end

function SWEP:Think()
end
