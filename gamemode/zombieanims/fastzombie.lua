function CLASS.CalcMainActivity(ply, velocity)
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() or not wep.GetClimbing or not wep.GetPounceTime then return end

	if wep:GetClimbing() then
		return ACT_ZOMBIE_CLIMB_UP, -1
	end

	if wep:GetPounceTime() > 0 then
		return ACT_ZOMBIE_LEAP_START, -1
	end

	if not ply:OnGround() or ply:WaterLevel() >= 3 then
		return ACT_ZOMBIE_LEAPING, -1
	end

	local speed = velocity:Length2DSqr()

	if speed > 256 and wep:GetSwinging() then --16^2
		return ACT_HL2MP_RUN_ZOMBIE, -1
	end

	if ply:Crouching() then
		return speed <= 1 and ACT_HL2MP_IDLE_CROUCH_ZOMBIE or ACT_HL2MP_WALK_CROUCH_ZOMBIE_01, -1
	end

	return ACT_HL2MP_RUN_ZOMBIE_FAST, -1
end

function CLASS.UpdateAnimation(ply, velocity, maxseqgroundspeed)
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() or not wep.GetClimbing or not wep.GetPounceTime or not wep.GetSwinging then return end

	if IsValid(ply:GetViewModel()) then
		ply:GetViewModel():SetPlaybackRate(2)
	end

	if wep:GetSwinging() then
		if not ply.PlayingFZSwing then
			ply.PlayingFZSwing = true
			ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY)
		end
	elseif ply.PlayingFZSwing then
		ply.PlayingFZSwing = false
		ply:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD) --ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY, true)
	end

	if wep:GetClimbing() then
		local vel = ply:GetVelocity()
		local speed = vel:LengthSqr()
		if speed > 64 then --8^2
			ply:SetPlaybackRate(math.Clamp(speed / 25600, 0, 1) * (vel.z < 0 and -1 or 1)) --160^2
		else
			ply:SetPlaybackRate(0)
		end

		return true
	end

	if wep:GetPounceTime() > 0 then
		ply:SetPlaybackRate(0.25)

		if not ply.m_PrevFrameCycle then
			ply.m_PrevFrameCycle = true
			ply:SetCycle(0)
		end

		return true
	elseif ply.m_PrevFrameCycle then
		ply.m_PrevFrameCycle = nil
	end

	if not ply:OnGround() or ply:WaterLevel() >= 3 then
		ply:SetPlaybackRate(1)

		if ply:GetCycle() >= 1 then
			ply:SetCycle(ply:GetCycle() - 1)
		end

		return true
	end
end

function CLASS.DoAnimationEvent(ply, event, data)
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_FRENZY, true)
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_RELOAD then
		return ACT_INVALID
	end
end
