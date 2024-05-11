function EFFECT:Init(data)
	local pos = data:GetOrigin()
	pos = pos + Vector(0, 0, 48)

	WorldSound("ambient/explosions/explode_9.wav", pos, 90, math.random(85, 95))

	local emitter = ParticleEmitter(pos)
		for i=1, math.random(14, 17) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand() * 64)
			particle:SetDieTime(math.Rand(1.7, 2.0))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(32)
			particle:SetEndSize(4)
			particle:SetColor(20, 100, 20)
			particle:SetRoll(math.Rand(0, 360))
		end
		for i=1, math.random(6, 9) do
			local particle = emitter:Add("particle/smokestack", pos)
			particle:SetVelocity(VectorRand() * 64)
			particle:SetDieTime(math.Rand(1.2, 1.6))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(16)
			particle:SetEndSize(4)
			particle:SetColor(0, 40, 0)
			particle:SetRoll(math.Rand(0, 360))
		end
		for i=1, math.random(14, 18) do
			local particle = emitter:Add("effects/fire_cloud1", pos + VectorRand() * 32)
			particle:SetVelocity(VectorRand() * 200)
			particle:SetDieTime(math.Rand(1.0, 1.25))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(24)
			particle:SetEndSize(15)
			particle:SetRoll(math.Rand(0, 360))
		end
	emitter:Finish()

	for i=1, math.random(9, 16) do
		local effectdata = EffectData()
			effectdata:SetOrigin(pos + VectorRand() * 16)
			effectdata:SetNormal(VectorRand())
		util.Effect("ember", effectdata)
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
	util.Effect("Explosion", effectdata)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
