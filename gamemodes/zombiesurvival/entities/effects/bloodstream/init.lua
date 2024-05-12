util.PrecacheSound("physics/flesh/flesh_bloody_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard2.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard3.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard4.wav")

local function CollideCallback(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true

		local pos = hitpos + hitnormal

		if math.random(1, 3) == 3 then
			WorldSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", hitpos, 50, math.random(95, 105))
		end

		util.Decal("Blood", pos, hitpos - hitnormal)

		particle:SetDieTime(0)
	end
end

function EFFECT:Init(data)
	local Pos = data:GetOrigin() + Vector(0,0,10)

	local emitter = ParticleEmitter(Pos)
	for i=1, data:GetMagnitude() do
		local particle = emitter:Add("noxctf/sprite_bloodspray"..math.random(1,8), Pos + VectorRand() * 8)
		particle:SetVelocity(VectorRand():Normalize() * math.random(90, 175) + Vector(0,0,80))
		particle:SetDieTime(math.Rand(3, 6))
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(230)
		particle:SetStartSize(math.Rand(10, 14))
		particle:SetEndSize(10)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-20, 20))
		particle:SetAirResistance(5)
		particle:SetBounce(0)
		particle:SetGravity(Vector(0, 0, -600))
		particle:SetCollide(true)
		particle:SetCollideCallback(CollideCallback)
		particle:SetLighting(true)
		particle:SetColor(255, 0, 0)
	end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
