function EFFECT:Init(data)
	local pos = data:GetOrigin()

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(40, 50)
		local grav = Vector(0, 0, -500)
		for i=1, math.random(14, 24) do
			local particle = emitter:Add("particles/smokey", pos)
			particle:SetVelocity(VectorRand():Normalize() * math.Rand(16, 64))
			particle:SetDieTime(math.Rand(0.9, 2.0))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(50)
			particle:SetStartSize(math.Rand(6, 12))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetCollide(true)
			particle:SetBounce(0.2)
			particle:SetColor(10, 255, 10)
			particle:SetAirResistance(math.random(30, 80))
			particle:SetGravity(grav)
		end
	emitter:Finish()

	util.Decal("Impact.AlienFlesh", pos + Vector(0,0,4), pos + Vector(0,0,-4))

	WorldSound("npc/antlion_grub/squashed.wav", pos, 80, math.random(95, 110))
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
