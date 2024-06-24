local ActCalcs = {}
local UpdateAnims = {}
local AnimEvents = {}

for classnum, ZombieClass in ipairs(ZombieClasses) do
	CLASS = {}
	include("zombieanims/" .. ZombieClass["ANIM"] .. ".lua")
	ActCalcs[classnum] = CLASS.CalcMainActivity
	UpdateAnims[classnum] = CLASS.UpdateAnimation
	AnimEvents[classnum] = CLASS.DoAnimationEvent
	CLASS = nil
end

function GM:CalcMainActivity(ply, velocity)
	local plyTab = ply:GetTable()

	if ply:Team() == TEAM_UNDEAD and ply.Class and ActCalcs[ply.Class] then
		local ideal, override = ActCalcs[ply.Class](ply, velocity)
		if ideal then
			return ideal, override
		end
	end

	-- Handle landing
	local onground = ply:OnGround()
	if onground and not plyTab.m_bWasOnGround then
		ply:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_LAND, true)
		plyTab.m_bWasOnGround = true
	end
	--

	-- Handle jumping
	-- airwalk more like hl2mp, we airwalk until we have 0 velocity, then it's the jump animation
	-- underwater we're alright we airwalking
	local waterlevel = ply:WaterLevel()
	if plyTab.m_bJumping then
		if plyTab.m_bFirstJumpFrame then
			plyTab.m_bFirstJumpFrame = false
			ply:AnimRestartMainSequence()
		end

		if waterlevel >= 2 or CurTime() - plyTab.m_flJumpStartTime > 0.2 and onground then
			plyTab.m_bJumping = false
			plyTab.m_fGroundTime = nil
			ply:AnimRestartMainSequence()
		else
			return ACT_MP_JUMP, -1
		end
	elseif not onground and waterlevel <= 0 then
		if not plyTab.m_fGroundTime then
			plyTab.m_fGroundTime = CurTime()
		elseif CurTime() > plyTab.m_fGroundTime and velocity:Length2D() < 0.5 then
			plyTab.m_bJumping = true
			plyTab.m_bFirstJumpFrame = false
			plyTab.m_flJumpStartTime = 0
		end
	end
	--

	-- Handle ducking
	if ply:Crouching() then
		if velocity:Length2DSqr() >= 1 then
			return ACT_MP_CROUCHWALK, -1
		end

		return ACT_MP_CROUCH_IDLE, -1
	end
	--

	-- Handle swimming
	if not onground and waterlevel >= 2 then
		return ACT_MP_SWIM, -1
	end
	--

	local len2d = velocity:Length2DSqr()
	if len2d >= 22500 then -- 150^2
		return ACT_MP_RUN, -1
	end

	if len2d >= 1 then
		return ACT_MP_WALK, -1
	end

	return ACT_MP_STAND_IDLE, -1
end

function GM:UpdateAnimation(ply, velocity, maxseqgroundspeed)
	if ply:Team() == TEAM_UNDEAD and ply.Class and UpdateAnims[ply.Class] then
		if UpdateAnims[ply.Class](ply, velocity, maxseqgroundspeed) then
			return
		end
	end

	local len = velocity:LengthSqr()
	local rate

	if len > 1 then
		rate = math.min(len / maxseqgroundspeed ^ 2, 2)
	else
		rate = 1
	end

	-- if we're under water we want to constantly be swimming..
	if ply:WaterLevel() >= 2 then
		rate = math.max(rate, 0.5)
	end

	ply:SetPlaybackRate(rate)

	if CLIENT then
		GAMEMODE:GrabEarAnimation(ply)
		--GAMEMODE:MouthMoveAnimation(pl) -- Broken?
	end
end

function GM:DoAnimationEvent(ply, event, data)
	if ply:Team() == TEAM_UNDEAD and ply.Class and AnimEvents[ply.Class] then
		local eact = AnimEvents[ply.Class](ply, event, data)
		if eact then
			return eact
		end
	end

	if event == PLAYERANIMEVENT_FLINCH_HEAD then
		return ply:DoFlinchAnim(data)
	end

	return self.BaseClass:DoAnimationEvent(ply, event, data)
end