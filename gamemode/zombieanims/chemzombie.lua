function CLASS.CalcMainActivity(ply, velocity)
    if velocity:Length2DSqr() <= 1 then
		return ACT_IDLE, -1
	end

	return 1, 2
end
