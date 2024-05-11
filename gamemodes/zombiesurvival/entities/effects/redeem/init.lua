EFFECT.Time = math.Rand(5, 10)

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	if not pos then return end

	WorldSound("ambient/energy/whiteflash.wav", pos)

	local emitter = ParticleEmitter(pos)
		for x=1, math.random(150, 200) do
			local vecRan = VectorRand()
			vecRan = vecRan * math.random(24, 64)
			vecRan.z = math.Rand(-32, -1)
			local particle = emitter:Add("sprites/gmdm_pickups/light", pos + vecRan)
			particle:SetVelocity(Vector(0,0,math.Rand(16, 64)))
			particle:SetDieTime(math.Rand(1.2, 2.0))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(150)
			particle:SetStartSize(math.Rand(7, 8))
			particle:SetEndSize(1)
			particle:SetColor(255, 255, 255)
			particle:SetRoll(math.random(90, 360))
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
