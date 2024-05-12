function EFFECT:Init(data)
	self.Entity:SetModel("models/props_debris/wood_board05a.mdl")

	local yaw = math.Clamp(tonumber(GetConVarNumber("zs_barricadekityaw")), -180, 180)
	local aimvec = MySelf:GetAimVector()
	local shootpos = MySelf:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = MySelf})

	self.Entity:SetPos(tr.HitPos)

	if tr.HitNonWorld or tr.HitSky then
		self.Entity:SetColor(255, 0, 0, 180)
	elseif tr.HitWorld then
		self.Entity:SetColor(30, 255, 30, 180)
	else
		local right = aimvec:Angle():Right():Angle()
		right.pitch = yaw
		right = right:Forward()
		local tr1 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * 42, filter = MySelf})
		local tr2 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * -42, filter = MySelf})
		if (tr1.HitWorld or tr2.HitWorld) and not tr1.HitSky and not tr2.HitSky then
			self.Entity:SetColor(30, 255, 30, 180)
		else
			self.Entity:SetColor(255, 0, 0, 180)
		end
	end

	local angles = aimvec:Angle()
	angles.roll = math.NormalizeAngle(90 + yaw)
	self.Entity:SetAngles(angles)
	self.DieTime = RealTime() + 0.04
end

function EFFECT:Think()
	return RealTime() < self.DieTime
end

function EFFECT:Render()
	self.Entity:SetMaterial("models/debug/debugwhite")
	self.Entity:DrawModel()
end
