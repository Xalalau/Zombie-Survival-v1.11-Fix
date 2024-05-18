EFFECT.Time = math.Rand(5, 10)

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	if not pos then return end

	EmitSound("items/suitchargeok1.wav", pos, 0, CHAN_AUTO, 1, 80, 0, math.random(90, 110))

	local emitter = ParticleEmitter(pos)
		for i=1, math.random(9, 14) do
			local vNormal = VectorRand()
			for x=1, math.random(76, 94), 2 do
				local particle = emitter:Add("sprites/light_glow02_add", pos + vNormal * x)
				particle:SetVelocity(vNormal * math.random(8, 16) - Vector(0,0,math.random(-16, -4)))
				particle:SetDieTime(x * 0.05)
				particle:SetStartAlpha(255)
				particle:SetEndAlpha(150)
				particle:SetStartSize(math.Rand(4, 5))
				particle:SetEndSize(1)
				particle:SetColor(Color(255, 255, math.random(0, 50)))
				particle:SetRoll(math.random(90, 360))
			end
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
