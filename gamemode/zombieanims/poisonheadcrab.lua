function CLASS.CalcMainActivity(ply, velocity)
    local wep = ply:GetActiveWeapon()
	if wep:IsValid() then
		if wep:ShouldPlayLeapAnimation() then
			return 1, 7
		end

		if wep:IsGoingToSpit() then
			return 1, 2
		end
	end

	if ply:OnGround() then
		if velocity:Length2DSqr() > 1 then
			return ACT_RUN, -1
		end

		return 1, 4
	end

	return 1, 6
end

function CLASS.UpdateAnimation(ply, velocity, maxseqgroundspeed)
    local seq = ply:GetSequence()
	if seq == 2 then
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() and wep.SpitWindUp then
			local spitend = wep:GetNextSpit()
			local lerp = 1 - math.max(0, spitend - CurTime()) / wep.SpitWindUp

			if lerp == 1 then
				ply:SetCycle(0.6 + math.sin(CurTime() * math.pi) * 0.1)
			else
				ply:SetCycle(lerp * 0.6)
			end
			ply:SetPlaybackRate(0)

			return true
		end
	elseif seq == 7 then
		local wep = ply:GetActiveWeapon()
		if wep:IsValid() and wep.PounceWindUp then
			local spitend = wep:GetNextLeap()
			local lerp = 1 - math.max(0, spitend - CurTime()) / wep.PounceWindUp

			if lerp == 1 then
				ply:SetCycle(0.7 + math.sin(CurTime() * math.pi) * 0.1)
			else
				ply:SetCycle(lerp * 0.7)
			end
			ply:SetPlaybackRate(0)

			return true
		end
	end
end
