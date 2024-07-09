SWEP.Base = "weapon_zs_base_enemy"

SWEP.ViewModel = "models/weapons/v_knife_t.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Delay = 0.4
SWEP.Secondary.Delay = 0.22

SWEP.HitDetection = {
	traceEndDistance = 35,
	traceEndExtraHeight = 10,
	hitScanHeight = 1.7,
	hitScanRadius = 10,
	upZThreshold = 0.25,
	upZHeight = 47,
	upZaimDistance = 1,
	downZThreshold = 0.25,
	downZHeight = 0,
	downZaimDistance = 10
}

function SWEP:Precache()
	util.PrecacheSound("npc/headcrab/attack1.wav")
	util.PrecacheSound("npc/headcrab/attack2.wav")
	util.PrecacheSound("npc/headcrab/attack3.wav")
	util.PrecacheSound("npc/headcrab/headbite.wav")
	util.PrecacheSound("npc/headcrab/idle"..math.random(1,2)..".wav")
end
