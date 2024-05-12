-- Be sure to assign your custom animations at the bottom of this file.

-- These index numbers are related to the class numbers in zs_options.lua
local SpecialAnims = {}
SpecialAnims[1] = function(pl, anim)
	local seq
	if 0 < pl:GetVelocity():Length() then
		seq = pl.ZomAnim
	else
		pl.ZomAnim = math.random(1, 3)
		seq = pl:SelectWeightedSequence(ACT_IDLE)
	end

	if pl:GetSequence() ~= seq then
		pl:ResetSequence(seq)
	end
end

SpecialAnims[2] = function(pl, anim)
	local seq = -1

	if not pl:OnGround() then
		seq = 5
	elseif 0 < pl:GetVelocity():Length() then
		seq = pl:SelectWeightedSequence(ACT_RUN)
	else
		seq = pl:SelectWeightedSequence(ACT_IDLE)
	end

	if pl:GetSequence() ~= seq then
		pl:ResetSequence(seq)
	end
end

SpecialAnims[3] = function(pl, anim)
	if 0 < pl:GetVelocity():Length() then
		local seq = pl:SelectWeightedSequence(ACT_WALK)
		if pl:GetSequence() ~= seq then
			pl:ResetSequence(seq)
		end
	else
		local seq = pl:SelectWeightedSequence(ACT_IDLE)
		if pl:GetSequence() ~= seq then
			pl:ResetSequence(seq)
		end
	end
end

local function ZombieTorsoAnim(pl, anim)
	if 0 < pl:GetVelocity():Length() then
		if pl:GetSequence() ~= 2 then
			pl:ResetSequence(2)
		end
	else
		local seq = pl:SelectWeightedSequence(ACT_IDLE)
		if pl:GetSequence() ~= seq then
			pl:ResetSequence(seq)
		end
	end
end

SpecialAnims[4] = ZombieTorsoAnim

SpecialAnims[5] = function(pl, anim)
	if 0 < pl:GetVelocity():Length() then
		local seq = pl:SelectWeightedSequence(ACT_WALK)
		if pl:GetSequence() ~= seq then
			pl:ResetSequence(seq)
		end
	elseif pl:GetSequence() ~= 1 then
		pl:ResetSequence(1)
	end
end

local function HeadcrabAnim(pl, anim)
	local seq
	if pl:OnGround() then
		if 0 < pl:GetVelocity():Length() then
			seq = pl:SelectWeightedSequence(ACT_RUN)
		else
			seq = 1
		end
	else
		seq = pl:LookupSequence("Drown")
	end

	if pl:GetSequence() ~= seq then
		pl:ResetSequence(seq)
	end
end

SpecialAnims[6] = HeadcrabAnim

SpecialAnims[7] = HeadcrabAnim

SpecialAnims[8] = function(pl, anim)
	local seq = 4
	if pl:OnGround() then
		if 0 < pl:GetVelocity():Length() then
			seq = pl:SelectWeightedSequence(ACT_RUN)
		end
	else
		seq = pl:LookupSequence("Drown")
	end

	if pl:GetSequence() ~= seq then
		pl:ResetSequence(seq)
	end
end

SpecialAnims[9] = ZombieTorsoAnim

local ATT = {}
ATT[PLAYER_RELOAD] = ACT_HL2MP_GESTURE_RELOAD
ATT[PLAYER_JUMP] = ACT_HL2MP_JUMP
ATT[PLAYER_ATTACK1] = ACT_HL2MP_GESTURE_RANGE_ATTACK

local novel = Vector(0,0,0)

local HoldActivityTranslate = {}
HoldActivityTranslate[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_FIST
HoldActivityTranslate[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_FIST
HoldActivityTranslate[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_FIST
HoldActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_FIST
HoldActivityTranslate[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_FISt
HoldActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
HoldActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_FIST
HoldActivityTranslate[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_FIST
HoldActivityTranslate[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_MELEE

function GM:SetPlayerAnimation(pl, anim)
	if pl:Team() == TEAM_UNDEAD then
		SpecialAnims[pl.Class](pl, anim)
	else
		local act = ACT_HL2MP_IDLE
		local OnGround = pl:OnGround()

		local wep = pl:GetActiveWeapon()

		if ATT[anim] then
			act = ATT[anim]
			if act == ACT_HL2MP_GESTURE_RANGE_ATTACK or act == ACT_HL2MP_GESTURE_RELOAD then
				pl:RestartGesture(pl:Weapon_TranslateActivity(act))
				if act == ACT_HL2MP_GESTURE_RANGE_ATTACK then
					pl:Weapon_SetActivity(pl:Weapon_TranslateActivity(ACT_RANGE_ATTACK1), 0)
				end
				return
			end
		else
			if OnGround then
				if pl:Crouching() then
					act = ACT_HL2MP_IDLE_CROUCH
					if pl:GetVelocity() ~= novel then
						act = ACT_HL2MP_WALK_CROUCH
					end
				elseif pl:GetVelocity() ~= novel then
					act = ACT_HL2MP_RUN
				end
			else
				act = ACT_HL2MP_JUMP
			end
		end

		local seq
		if pl:GetNetworkedBool("IsHolding") then
			seq = pl:SelectWeightedSequence(HoldActivityTranslate[act] or -1)
		else
			seq = pl:SelectWeightedSequence(pl:Weapon_TranslateActivity(act))
		end

		if seq == -1 then
			seq = pl:SelectWeightedSequence(ACT_HL2MP_JUMP_SLAM)
		end

		if pl:GetSequence() ~= seq then
			pl:ResetSequence(seq)
		end
	end
end
