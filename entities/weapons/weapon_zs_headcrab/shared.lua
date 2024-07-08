SWEP.Base = "weapon_zs_base_enemy"

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Delay = 0.4
SWEP.Secondary.Delay = 0.22

SWEP.HitDetection = {
	traceForwardLenght = 35,
	traceForwardHeight = 10,
	entHeight = 1.7,
	hitScanRadius = 10,
	upZThreshold = 0.25,
	upZLenght = 47,
	upZAimLenght = 1,
	downZThreshold = 0.25,
	downZLenght = 0,
	downZAimLenght = 10,
	midZLenght = nil,
	midZAimLenght = nil
}

function SWEP:Precache()
	util.PrecacheSound("npc/headcrab/attack1.wav")
	util.PrecacheSound("npc/headcrab/attack2.wav")
	util.PrecacheSound("npc/headcrab/attack3.wav")
	util.PrecacheSound("npc/headcrab/headbite.wav")
	util.PrecacheSound("npc/headcrab/idle"..math.random(1,2)..".wav")
end
