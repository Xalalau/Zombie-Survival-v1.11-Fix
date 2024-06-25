function CLASS.CalcMainActivity(ply, velocity)
	local wep = ply:GetActiveWeapon()
	if wep.GetThrowAnimTime and CurTime() < wep:GetThrowAnimTime() then
		return ACT_RANGE_ATTACK2, -1
	end

	if velocity:Length2DSqr() <= 1 then
		return ACT_IDLE, -1
	end

	return ACT_WALK, -1
end

function CLASS.DoAnimationEvent(ply, event, data)
    if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MELEE_ATTACK1, true)
		return ACT_INVALID
	end
end