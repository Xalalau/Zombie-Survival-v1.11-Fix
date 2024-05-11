function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local mag = data:GetMagnitude()
	WorldSound("physics/flesh/flesh_bloody_break.wav", pos, 80, math.random(50, 100))

	local LightColor = render.GetLightColor(pos) * 255
	LightColor.r = math.Clamp( LightColor.r, 70, 255 )

	local emitter = ParticleEmitter(pos)
		for i=1, 16 do
			local particle = emitter:Add("effects/blood_core", pos)
			particle:SetVelocity(norm * 32 + VectorRand() * 16)
			particle:SetDieTime(math.Rand(1.5, 2.5))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(1)
			particle:SetStartSize(math.random(15, 16))
			particle:SetEndSize(math.random(14, 15))
			particle:SetRoll(180)
			particle:SetColor(LightColor.r*0.5, 0, 0)
		end
		local particle = emitter:Add("effects/blood_core", pos)
		particle:SetVelocity(norm * 32)
		particle:SetDieTime(math.Rand(2.25, 3))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(64)
		particle:SetStartSize(math.random(38, 72))
		particle:SetEndSize(math.random(24, 38))
		particle:SetRoll(180)
		particle:SetColor(LightColor.r*0.5, 0, 0)
	emitter:Finish()

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(Vector(0,0,1))
		effectdata:SetMagnitude(math.random(1000, 1300))
	util.Effect("bloodstream", effectdata)

	for i=1, 3 do
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetNormal(norm)
			effectdata:SetMagnitude(mag * math.Rand(0.7, 1.3))
		util.Effect("bloodstream", effectdata)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
