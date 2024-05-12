function EFFECT:Init(data)
	self.EndPos = data:GetOrigin()
	
	local wep = data:GetEntity()
	if wep == MySelf:GetActiveWeapon() then
		local attach = MySelf:GetViewModel():GetAttachment(data:GetAttachment())
		if attach then
			self.StartPos = attach.Pos
		else
			self.StartPos = data:GetStart()
		end
	elseif wep:IsValid() then
		local attach = wep:GetAttachment(data:GetAttachment())
		if attach then
			self.StartPos = attach.Pos
		else
			self.StartPos = data:GetStart()
		end
	else
		self.StartPos = data:GetStart()
	end

	self.Dir = self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS(self.StartPos, self.EndPos)

	self.TracerTime = math.max(0.05, math.min(0.35, self.EndPos:Distance(self.StartPos) * 0.0001))

	self.DieTime = CurTime() + self.TracerTime
end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local matBeam = Material("Effects/spark")
--local matGlow = Material("sprites/glow04_noz")
function EFFECT:Render()
	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp(fDelta, 0, 1)

	render.SetMaterial(matBeam)

	local sinWave = math.sin(fDelta * math.pi)

	local endpos = self.EndPos - self.Dir * (fDelta - sinWave * 0.3)
	render.DrawBeam(endpos, self.EndPos - self.Dir * (fDelta + sinWave * 0.3), 2 + sinWave * 8, 1, 0, COLOR_YELLOW)

	--[[render.SetMaterial(matGlow)
	local siz = math.Rand(16, 24)
	render.DrawSprite(endpos, siz, siz, self.Col)]]
end
