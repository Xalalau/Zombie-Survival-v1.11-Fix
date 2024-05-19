util.PrecacheSound("physics/flesh/flesh_bloody_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard1.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard2.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard3.wav")
util.PrecacheSound("physics/flesh/flesh_squishy_impact_hard4.wav")

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	particle:SetDieTime(0)
	if math.random(1, 3) == 3 then
		EmitSound("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 0, CHAN_AUTO, 1, 50, 0, math.random(95, 105))
		util.Decal("Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
	end
end

local function CollideCallback(particle, hitpos, hitnormal)
	particle:SetDieTime(0)

	local pos = hitpos + hitnormal

	if math.random(1, 3) == 3 then
		EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav", hitpos, 0, CHAN_AUTO, 1, 50, 0, math.random(95, 105))
	end
	//EmitSound("physics/flesh/flesh_bloody_impact_hard1", hitpos, 0, CHAN_AUTO, 1, 60, 0, math.random(95, 105))
	util.Decal("Blood", pos, hitpos - hitnormal)

	local nhitnormal = hitnormal * 90
	local btype = particle.bType

	local emitter = ParticleEmitter(pos)
		for i=1, math.random(-4, 4) do
			local particle = emitter:Add("decals/blood"..math.random(1,8), pos)
			particle:SetVelocity(VectorRand():GetNormalized() * math.random(75, 150) + nhitnormal)
			particle:SetDieTime(3)
			particle:SetColor(255, 255, 255)
			particle:SetLighting(true)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(200)
			particle:SetStartSize(math.Rand(4, 6))
			particle:SetEndSize(4)
			particle:SetRoll(math.Rand(-25, 25))
			particle:SetRollDelta(math.Rand(-25, 25))
			particle:SetAirResistance(5)
			particle:SetBounce(0)
			particle:SetGravity(Vector(0, 0, -600))
			particle:SetCollide(true)
			particle:SetCollideCallback(CollideCallbackSmall)
		end
	emitter:Finish()
end

function EFFECT:Init(data)
	local Pos = data:GetOrigin() + Vector(0,0,10)

	local emitter = ParticleEmitter(Pos)
		for i=1, data:GetMagnitude() do
			local particle = emitter:Add("decals/blood"..math.random(1,8), Pos + VectorRand() * 6)
			//particle:SetVelocity((VectorRand():GetNormalized() * (math.random(30, 70) / 180) + VectorRand():GetNormalized():Angle()) * 80)
			particle:SetVelocity(VectorRand():GetNormalized() * math.random(90, 175) + Vector(0,0,80))
			particle:SetDieTime(math.Rand(3, 6))
			particle:SetColor(255, 255, 255)
			particle:SetLighting(true)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(200)
			particle:SetStartSize(math.Rand(14, 20))
			particle:SetEndSize(14)
			particle:SetRoll(math.Rand(-20, 20))
			particle:SetRollDelta(math.Rand(-20, 20))
			particle:SetAirResistance(5)
			particle:SetBounce(0)
			particle:SetGravity(Vector(0, 0, -600))
			particle:SetCollide(true)
			particle:SetCollideCallback(CollideCallback)
		end
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
