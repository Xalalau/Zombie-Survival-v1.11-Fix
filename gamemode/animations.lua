// Be sure to assign your custom animations at the bottom of this file.

// Poison Zombie
local PoisonZombieATT = {}
PoisonZombieATT[PLAYER_IDLE] = ACT_IDLE_ON_FIRE
PoisonZombieATT[PLAYER_WALK] = ACT_WALK
PoisonZombieATT[PLAYER_JUMP] = ACT_WALK
PoisonZombieATT[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
PoisonZombieATT[PLAYER_SUPERJUMP] = ACT_RANGE_ATTACK2

local function PoisonZombieAnim(ply, anim)
	local act = ACT_IDLE

	if PoisonZombieATT[anim] ~= nil then
		act = PoisonZombieATT[anim]
	else
		if ply:GetVelocity():Length() > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)
	/*if act == ACT_WALK then
		seq = 2
	end*/

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetPlaybackRate(1.0)
	ply:SetCycle(0)
	return true
end

local function ChemZombieAnim(ply, anim)
	local act = ACT_IDLE

	if PoisonZombieATT[anim] ~= nil then
		act = PoisonZombieATT[anim]
	else
		if ply:GetVelocity():Length() > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 2
	end

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetPlaybackRate(1.0)
	ply:SetCycle(0)
	return true
end

local WraithATT = {}
WraithATT[PLAYER_IDLE] = ACT_IDLE
WraithATT[PLAYER_WALK] = ACT_WALK
WraithATT[PLAYER_JUMP] = ACT_WALK
//WraithATT[PLAYER_ATTACK1] = ACT_RANGE_ATTACK1

local function WraithAnim(ply, anim)
	local act = ACT_IDLE

	if WraithATT[anim] ~= nil then
		act = WraithATT[anim]
	else
		if ply:GetVelocity():Length() > 0 then
			act = ACT_WALK
		end
	end

	/*if act == ACT_RANGE_ATTACK1 then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end*/

	local seq = ply:SelectWeightedSequence(act)
	if act == ACT_IDLE then
		seq = 1
	end

	ply:SetPlaybackRate(1.0)

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetCycle(0)
	return true
end

// Fast Zombie
local FastZombieATT = {}
FastZombieATT[PLAYER_IDLE] = ACT_IDLE
FastZombieATT[PLAYER_WALK] = ACT_RUN
FastZombieATT[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
FastZombieATT[PLAYER_SUPERJUMP] = ACT_CLIMB_UP

local function FastZombieAnim(ply, anim)
	local act = ACT_IDLE
	local OnGround = ply:OnGround()

	if FastZombieATT[anim] then
		act = FastZombieATT[anim]
	else
		if ply:GetVelocity():Length() > 0 then
			act = ACT_RUN
		end
	end

	if act == ACT_MELEE_ATTACK1 or act == ACT_CLIMB_UP then
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)

	if not OnGround and act ~= ACT_CLIMB_UP then
		seq = 3
	end

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetPlaybackRate(1.0)
	ply:SetCycle(0)
	return true
end

// Headcrab / Fast headcrab
local HeadcrabATT = {}
HeadcrabATT[PLAYER_IDLE] = ACT_IDLE
HeadcrabATT[PLAYER_WALK] = ACT_RUN
HeadcrabATT[PLAYER_ATTACK1] = ACT_RANGE_ATTACK1

local function HeadcrabAnim(ply, anim)
	local act = ACT_IDLE
	local OnGround = ply:OnGround()

	if HeadcrabATT[anim] then
		act = HeadcrabATT[anim]
	else
		if ply:GetVelocity():Length() > 0 then
			act = ACT_RUN
		end
	end

	if act == ACT_RANGE_ATTACK1 then
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)

	if not OnGround then
	    seq = "Drown"
	end

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	if seq == 5 then
		ply:SetPlaybackRate(1.0)
	else
		ply:SetPlaybackRate(0.3)
	end
	ply:SetCycle(0)
	return true
end

// Poison Headcrab
local PoisonHCATT = {}
PoisonHCATT[PLAYER_IDLE] = ACT_IDLE
PoisonHCATT[PLAYER_WALK] = ACT_RUN
PoisonHCATT[PLAYER_ATTACK1] = ACT_RANGE_ATTACK1
PoisonHCATT[PLAYER_SUPERJUMP] = "Spitattack"

local function PoisonHeadcrabAnim(ply, anim)
	local act = ACT_IDLE
	local OnGround = ply:OnGround()

	if PoisonHCATT[anim] then
		act = PoisonHCATT[anim]
	else
		if ply:GetVelocity():Length() > 0 then
			act = ACT_RUN
		end
	end

	if act == ACT_RANGE_ATTACK1 or act == "Spitattack" then
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)

	if not OnGround then
	    seq = "Drown"
	end

	if act == ACT_IDLE then
		seq = 4
	end

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	if seq == 4 then
		ply:SetPlaybackRate(1.0)
	else
		ply:SetPlaybackRate(0.2)
	end
	ply:SetCycle(0)
	return true
end

// Classic Zombie
local ZombieATT = {}
ZombieATT[PLAYER_IDLE] = ACT_IDLE
ZombieATT[PLAYER_WALK] = ACT_WALK
ZombieATT[PLAYER_JUMP] = ACT_WALK
ZombieATT[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
ZombieATT[PLAYER_SUPERJUMP] = ACT_IDLE_ON_FIRE

local function ZombieAnim(ply, anim)
	local act = ACT_IDLE

	if ZombieATT[anim] ~= nil then
		act = ZombieATT[anim]
	end

	if act == ACT_IDLE_ON_FIRE and 0 < ply:GetVelocity():Length() then
		act = ACT_WALK_ON_FIRE
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = ply.ZomAnim
	end

	if seq == ply.ZomAnim then
		ply:SetPlaybackRate(1.5)
	else
		ply:SetPlaybackRate(1.0)
	end
	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetCycle(0)
	return true
end

// Zombie Torso
local ZombieTorsoATT = {}
ZombieTorsoATT[PLAYER_IDLE] = ACT_IDLE
ZombieTorsoATT[PLAYER_WALK] = ACT_WALK
ZombieTorsoATT[PLAYER_JUMP] = ACT_WALK
ZombieTorsoATT[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1

local function ZombieTorsoAnim(ply, anim)
	local act = ACT_IDLE

	if ZombieTorsoATT[anim] then
		act = ZombieTorsoATT[anim]
	else
		if ply:GetVelocity():Length() > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_MELEE_ATTACK1 then
		ply:SetPlaybackRate(2)
		ply:RestartGesture(act)
		return true
	end

	local seq = ply:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 2
	end

	if ply:GetSequence() == seq then return true end
	ply:ResetSequence(seq)
	ply:SetPlaybackRate(1.0)
	ply:SetCycle(0)
	return true
end

local ATT = {}
ATT[PLAYER_RELOAD] = ACT_HL2MP_GESTURE_RELOAD
ATT[PLAYER_JUMP] = ACT_HL2MP_JUMP
ATT[PLAYER_ATTACK1] = ACT_HL2MP_GESTURE_RANGE_ATTACK

function GM:SetPlayerAnimation(ply, anim)
	if ply:Team() == ZSF.TEAM_UNDEAD then
		SpecialAnims[ply.Class](ply, anim)
		return
	end

	local act = ACT_HL2MP_IDLE
	local OnGround = ply:OnGround()

	if ATT[anim] then
		act = ATT[anim]
	else
		local Speed = ply:GetVelocity():Length()
		if OnGround and ply:Crouching() then
			act = ACT_HL2MP_IDLE_CROUCH
			if Speed > 0 then
				act = ACT_HL2MP_WALK_CROUCH
			end
		elseif Speed > 0 then
			act = ACT_HL2MP_RUN
		end
	end

	if act == ACT_HL2MP_GESTURE_RANGE_ATTACK or act == ACT_HL2MP_GESTURE_RELOAD then
		ply:RestartGesture(ply:Weapon_TranslateActivity(act))
		if act == ACT_HL2MP_GESTURE_RANGE_ATTACK then
			ply:Weapon_SetActivity(ply:Weapon_TranslateActivity(ACT_RANGE_ATTACK1), 0)
		end
		return
	end

	if not OnGround then
		act = ACT_HL2MP_JUMP
	end

	local seq = ply:SelectWeightedSequence(ply:Weapon_TranslateActivity(act))

	// Let's assume that no admins spawn any vehicles and that we always have a weapon.

	if ply:GetSequence() == seq then return end
	ply:SetPlaybackRate(1.0)
	ply:ResetSequence(seq)
	ply:SetCycle(0)
end

// These index numbers are related to the class numbers in zs_options.lua
SpecialAnims = {}
SpecialAnims[1] = ZombieAnim
SpecialAnims[2] = FastZombieAnim
SpecialAnims[3] = PoisonZombieAnim
SpecialAnims[4] = ChemZombieAnim
SpecialAnims[5] = WraithAnim
SpecialAnims[6] = HeadcrabAnim
SpecialAnims[7] = HeadcrabAnim
SpecialAnims[8] = PoisonHeadcrabAnim
SpecialAnims[9] = ZombieTorsoAnim
