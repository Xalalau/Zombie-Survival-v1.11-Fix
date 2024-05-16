function EFFECT:Init(data)
	local pos = data:GetOrigin()

	local emitter = ParticleEmitter(pos)
		for i=1, math.random(4, 10) do
			local particle = emitter:Add("particles/smokey", pos)
			particle:SetVelocity(VectorRand():Normalize() * math.Rand(16, 64))
			particle:SetDieTime(math.Rand(0.9, 2.0))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(50)
			particle:SetStartSize(math.Rand(8, 16))
			particle:SetEndSize(5)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetCollide(true)
			particle:SetColor(Color(10, 255, 10))
			particle:SetAirResistance(math.random(30, 80))
		end
	emitter:Finish()

	util.Decal("AlienBlood", pos + VectorRand() * 4, pos + VectorRand() * 4)

	WorldSound("npc/antlion_grub/squashed.wav", pos, 90, math.random(95, 110))
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
