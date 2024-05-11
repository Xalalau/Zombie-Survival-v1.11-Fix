function EFFECT:Init(data)
	local ent = data:GetEntity()

	if !(ent:IsValid() and ent:IsPlayer()) then return end

	self.Ent = ent
	self.NextPuff = RealTime() + 0.5
end

function EFFECT:Think()
	if RealTime() < self.NextPuff then return true end
	local ent = self.Ent
	if !(ent:IsValid() and ent:IsPlayer() and ent:Alive()) then return false end

	local pos = ent:GetPos() + Vector(0,0,40)
		local emitter = ParticleEmitter(pos)
		for i=1, math.random(6, 9) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand() * 16 + Vector(0,0,32) + ent:GetVelocity())
			particle:SetDieTime(math.Rand(0.35, 0.75))
			particle:SetStartAlpha(245)
			particle:SetEndAlpha(40)
			particle:SetStartSize(12)
			particle:SetEndSize(10)
			particle:SetColor(20, 100, 20)
			particle:SetRoll(math.Rand(0, 360))
		end
	emitter:Finish()	

	return true
end

function EFFECT:Render()
end
