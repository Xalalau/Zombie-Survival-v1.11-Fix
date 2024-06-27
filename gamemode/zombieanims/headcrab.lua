function CLASS.CalcMainActivity(ply, velocity)
	if ply:OnGround() then
		if velocity:Length2DSqr() > 1 then
			return ACT_RUN, -1
		end

		return 1, 1
	end

	if ply:WaterLevel() >= 3 then
		return 1, 6
	end

	return 1, 5
end

function CLASS.UpdateAnimation(ply, velocity, maxseqgroundspeed)
	local seq = ply:GetSequence()
	if seq == 5 then
		if not ply.m_PrevFrameCycle then
			ply.m_PrevFrameCycle = true
			ply:SetCycle(0)
		end

		ply:SetPlaybackRate(1.5)

		return true
	elseif ply.m_PrevFrameCycle then
		ply.m_PrevFrameCycle = nil
	end

	local len2d = velocity:Length2D()
	if len2d > 1 then
		ply:SetPlaybackRate(math.min(len2d / maxseqgroundspeed * 0.5, 2))
	else
		ply:SetPlaybackRate(1)
	end

	return true
end
