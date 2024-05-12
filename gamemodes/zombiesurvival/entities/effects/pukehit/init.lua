function EFFECT:Think()
	return false
end

function EFFECT:Render()
end

local function CollideCallback(particle, hitpos, hitnormal)
	particle:SetDieTime(0)
	if math.random(1, 3) == 1 then
		WorldSound("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
	end

	util.Decal("Impact.Antlion", hitpos + hitnormal, hitpos - hitnormal)
end

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local normal = data:GetNormal() * -1

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(28, 32)
	local grav = Vector(0, 0, -500)
	for i=1, math.random(3, 5) do
		local particle = emitter:Add("decals/Yblood"..math.random(1,6), pos)
		particle:SetVelocity(VectorRand():Normalize() * math.Rand(16, 64))
		particle:SetDieTime(math.Rand(2.5, 4.0))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(50)
		particle:SetStartSize(math.Rand(2, 4))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetCollide(true)
		particle:SetBounce(0)
		particle:SetGravity(grav)
		particle:SetCollideCallback(CollideCallback)
	end
	emitter:Finish()

	util.Decal("YellowBlood", pos + normal, pos - normal)

	WorldSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", pos, 80, math.random(95, 110))
end
