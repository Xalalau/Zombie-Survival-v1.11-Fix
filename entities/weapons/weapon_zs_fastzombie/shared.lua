SWEP.Base = "weapon_zs_base_enemy"

SWEP.ViewModel = "models/weapons/v_fza.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

SWEP.Primary.Delay = 0.4

SWEP.Secondary.Delay = 0.22

SWEP.MeleeHitDetection = {
	traceStartGet = "GetShootPos",
	traceEndGetNormal = "GetAimVector", 
	traceEndDistance = 55,
	traceEndExtraHeight = 0,
	hitScanHeight = 55,
	hitScanRadius = 7,
	upZThreshold = 0.8,
	upZHeight = 20,
	upZaimDistance = 5,
	downZThreshold = -0.85,
	downZHeight = 45,
	downZaimDistance = 5,
	midZHeight = 0,
	midZaimDistance = 13
}

-- Shutup.
function SWEP:Precache()
	util.PrecacheSound("npc/fast_zombie/fz_scream1.wav")
	util.PrecacheSound("npc/zombie/claw_strike1.wav")
	util.PrecacheSound("npc/zombie/claw_strike2.wav")
	util.PrecacheSound("npc/zombie/claw_strike3.wav")
	util.PrecacheSound("npc/zombie/claw_miss1.wav")
	util.PrecacheSound("npc/zombie/claw_miss2.wav")
	util.PrecacheSound("npc/zombie/zo_attack1.wav")
	util.PrecacheSound("npc/fast_zombie/fz_alert_close1.wav")
	util.PrecacheSound("npc/zombie/zombie_die1.wav")
	util.PrecacheSound("npc/fast_zombie/fz_frenzy1.wav")
	util.PrecacheSound("physics/flesh/flesh_strider_impact_bullet1.wav")
	util.PrecacheSound("player/footsteps/metalgrate1.wav")
	util.PrecacheSound("player/footsteps/metalgrate2.wav")
	util.PrecacheSound("player/footsteps/metalgrate3.wav")
	util.PrecacheSound("player/footsteps/metalgrate4.wav")
end

function SWEP:GetClimbing()
	return self:GetDTBool(0)
end

function SWEP:GetSwinging()
	return self:GetDTBool(1)
end

function SWEP:GetPounceTime()
	return self:GetDTFloat(0)
end

function SWEP:GetNextSwing()
	return self:GetDTFloat(1)
end
