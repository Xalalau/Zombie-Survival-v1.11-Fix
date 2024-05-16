function EFFECT:Init(data)
	self.Entity:SetModel("models/props_debris/wood_board05a.mdl")

	local ply = LocalPlayer()
	local aimvec = ply:GetAimVector()
	local shootpos = ply:GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = ply})

	self.Entity:SetPos(tr.HitPos)

	if tr.HitNonWorld then
		self.Entity:SetColor(Color(255, 0, 0, 180))
	elseif tr.HitWorld then
		self.Entity:SetColor(Color(30, 255, 30, 180))
	else
		local right = aimvec:Angle():Right()
		local tr1 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * 42, filter = ply})
		local tr2 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * -42, filter = ply})
		if tr1.HitWorld or tr2.HitWorld then
			self.Entity:SetColor(Color(30, 255, 30, 180))
		else
			self.Entity:SetColor(Color(255, 0, 0, 180))
		end
	end

	local angles = aimvec:Angle()
	angles.roll = 90
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
