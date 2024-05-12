function EFFECT:Init(data)
	local ent = data:GetEntity()
	self.Ent = ent
	if ent and ent:IsPlayer() then
		WorldSound("weapons/physcannon/physcannon_charge.wav", ent:GetPos(), 80, 220)

		self.Emitter = ParticleEmitter(ent:GetPos() + Vector(0,0,32))
		self.DieTime = CurTime() + 1
	else
		self.DieTime = 0
	end
end

function EFFECT:Think()
	if self.DieTime < CurTime() then
		if self.Emitter then
			self.Emitter:Finish()
		end
		return false
	end

	local pos = self.Entity:GetPos()

	for i=1, math.random(3, 4) do
		local particle = self.Emitter:Add("effects/spark", pos + Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0):Normalize() * math.Rand(-64, 64))
		particle:SetVelocity(Vector(0, 0, math.Rand(750, 1450)))
		particle:SetDieTime(math.Rand(0.6, 1.5))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(64)
		particle:SetStartSize(math.Rand(18, 22))
		particle:SetEndSize(0)
		particle:SetAirResistance(155)
		particle:SetRoll(0)
		local rand = math.random(1, 6)
		if rand == 1 then
			particle:SetColor(20, 80, 255)
		elseif rand == 2 then
			particle:SetColor(40, 255, 40)
		elseif rand == 3 then
			particle:SetColor(255, 40, 40)
		else
			particle:SetColor(200, 200, 255)
		end
	end

	return true
end

function EFFECT:Render()
end
