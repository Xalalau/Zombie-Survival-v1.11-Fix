function CLASS.CalcMainActivity(ply, velocity)
    if ply:WaterLevel() >= 3 then
		return 1, ply:LookupSequence("g_console_surprised")
	end

	local len = velocity:Length2DSqr()
	if len <= 1 then
		return 1, ply:LookupSequence("idle01")
	end

	return 1, ply:LookupSequence("walk_all")
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
	end
end