SWEP.Base = "weapon_zs_base_enemy"

SWEP.ViewModel = "models/Weapons/v_zombiearms.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Delay = 1.4

SWEP.MeleeHitDetection = {
	traceStartGet = "GetShootPos",
	traceEndGetNormal = "GetAimVector", 
	traceStartExtraHeight = -30,
	traceEndDistance = 65,
	traceEndExtraHeight = -20,
	traceMask = MASK_SHOT,
	hitScanHeight = 15,
	hitScanRadius = 7,
	upZThreshold = 0.8,
	upZHeight = 10,
	upZaimDistance = 5,
	downZThreshold = -0.85,
	downZHeight = 12,
	downZaimDistance = 5,
	midZHeight = 0,
	midZaimDistance = 13
}

function SWEP:Precache()
	util.PrecacheSound("npc/zombie/zombie_voice_idle1.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle2.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle3.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle4.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle5.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle6.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle7.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle8.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle9.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle10.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle11.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle12.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle13.wav")
	util.PrecacheSound("npc/zombie/zombie_voice_idle14.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/zombie/zo_attack1.wav")
	util.PrecacheSound("npc/zombie/zo_attack2.wav")
	util.PrecacheSound("npc/zombie/zombie_die1.wav")
	util.PrecacheSound("npc/zombie/zombie_die2.wav")
	util.PrecacheSound("npc/zombie/zombie_die3.wav")
end
