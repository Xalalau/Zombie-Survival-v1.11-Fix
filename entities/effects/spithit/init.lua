function EFFECT:Init(data)
	local pos = data:GetOrigin()

	local emitter = ParticleEmitter(pos)
		for i=1, math.random(4, 10) do
			local particle = emitter:Add("particles/smokey", pos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(16, 64))
			particle:SetDieTime(math.Rand(0.9, 2.0))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(50)
			particle:SetStartSize(math.Rand(8, 16))
			particle:SetEndSize(5)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetCollide(true)
			particle:SetColor(10, 255, 10)
			particle:SetAirResistance(math.random(30, 80))
		end
	emitter:Finish()

	util.Decal("AlienBlood", pos + VectorRand() * 4, pos + VectorRand() * 4)

	EmitSound("npc/antlion_grub/squashed.wav", pos, 0, CHAN_AUTO, 1, 90, 0, math.random(95, 110))
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
