function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local mag = data:GetMagnitude()
	local ent = data:GetEntity()
	local scale = math.Round(data:GetScale())

	if ent:IsPlayer() then
		pos = ent:GetAttachment(1).Pos
		local effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetEntity(ent)
			effectdata:SetScale(DISMEMBER_HEAD)
		util.Effect("dismemberment", effectdata)
	end

	WorldSound("physics/flesh/flesh_bloody_break.wav", pos, 77, math.random(50, 100))
	WorldSound("physics/body/body_medium_break"..math.random(2, 4)..".wav", pos, 77, math.random(90, 110))

	local emitter = ParticleEmitter(pos)
	for i=1, 12 do
		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(1,8), pos)
		particle:SetVelocity(norm * 32 + VectorRand() * 16)
		particle:SetDieTime(math.Rand(1.5, 2.5))
		particle:SetStartAlpha(200)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.Rand(13, 14))
		particle:SetEndSize(math.Rand(10, 12))
		particle:SetRoll(180)
		particle:SetDieTime(3)
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)
	end
	local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(1,8), pos)
	particle:SetVelocity(norm * 32)
	particle:SetDieTime(math.Rand(2.25, 3))
	particle:SetStartAlpha(200)
	particle:SetEndAlpha(0)
	particle:SetStartSize(math.Rand(28, 32))
	particle:SetEndSize(math.Rand(14, 28))
	particle:SetRoll(180)
	particle:SetColor(255, 0, 0)
	particle:SetLighting(true)
	emitter:Finish()

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetMagnitude(math.random(3, 6))
		effectdata:SetScale(scale)
	util.Effect("bloodstream", effectdata)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
