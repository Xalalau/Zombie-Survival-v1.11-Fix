function CLASS.CalcMainActivity(ply, velocity)
    if ply:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	end

	if ply:WaterLevel() >= 3 then
		return ACT_HL2MP_SWIM_PISTOL, -1
	end

	local len = velocity:Length2DSqr()
	if len <= 1 then
		if ply:Crouching() and ply:OnGround() then
			return ACT_HL2MP_IDLE_CROUCH_FIST, -1
		end

		return ACT_HL2MP_IDLE_KNIFE, -1
	end

	if ply:Crouching() and ply:OnGround() then
		return ACT_HL2MP_WALK_CROUCH_KNIFE, -1
	end

	if len < 2800 then
		return ACT_HL2MP_WALK_KNIFE, -1
	end

	return ACT_HL2MP_RUN_KNIFE, -1
end

function CLASS.UpdateAnimation(ply, velocity, maxseqgroundspeed)
    local len2d = velocity:Length()
	if len2d > 1 then
		ply:SetPlaybackRate(math.min(len2d / maxseqgroundspeed, 3))
	else
		ply:SetPlaybackRate(1)
	end

	return true
end

function CLASS.DoAnimationEvent(ply, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL, true)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true)
		return ACT_INVALID
	end
end