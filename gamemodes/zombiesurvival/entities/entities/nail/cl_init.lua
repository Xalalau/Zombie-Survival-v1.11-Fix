include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:OnRemove()
	local normal = self:GetForward() * -1
	local pos = self:GetPos() + normal * 8

	WorldSound("physics/metal/metal_box_impact_bullet"..math.random(1, 3)..".wav", pos, 80, math.random(90, 110))

	local emitter = ParticleEmitter(pos)
	emitter:SetNearClip(28, 32)
	for i=1, math.random(10, 20) do
		local vNormal = (VectorRand() * 0.35 + normal):Normalize()
		local particle = emitter:Add("effects/spark", pos + vNormal * 2)
		particle:SetVelocity(vNormal * math.Rand(24, 90))
		particle:SetDieTime(math.Rand(2.5, 3))
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(255)
		particle:SetStartSize(math.Rand(2, 3))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-5, 5))
		particle:SetCollide(true)
		particle:SetBounce(0.8)
		particle:SetGravity(Vector(0,0,-500))
	end
	emitter:Finish()
end
