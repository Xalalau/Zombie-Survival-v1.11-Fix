SWEP.Base = "weapon_zs_base_enemy"

SWEP.ViewModel = "models/weapons/v_pza.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Delay = 2

SWEP.HitDetection = {
	traceStartGet = "GetShootPos",
	traceEndDistance = 75,
	traceEndExtraHeight = 0,
	traceEndGetNormal = "GetAimVector", 
	traceMask = MASK_SHOT,
	hitScanHeight = 55,
	hitScanRadius = 5,
	upZThreshold = 0.8,
	upZHeight = 20,
	upZaimDistance = 5,
	downZThreshold = -0.85,
	downZHeight = 45,
	downZaimDistance = 5,
	midZHeight = 0,
	midZaimDistance = 13
}

function SWEP:Precache()
	util.PrecacheSound("npc/antlion/distract1.wav")
	util.PrecacheSound("ambient/machines/slicer1.wav")
	util.PrecacheSound("ambient/machines/slicer2.wav")
	util.PrecacheSound("ambient/machines/slicer3.wav")
	util.PrecacheSound("ambient/machines/slicer4.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
end
