EFFECT.Time = math.Rand(5, 10)

function EFFECT:Init(data)
	local modelid = data:GetMagnitude()

	self.Entity:SetModel(HumanGibs[modelid])

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )


	if modelid > 4 then
		self.Entity:SetMaterial("models/flesh")
	end

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetAngle(Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360)))
		phys:ApplyForceCenter(VectorRand() * math.Rand(5000, 10000))
	end
	self.Time = RealTime() + math.random(8, 12)
	self.Emitter = ParticleEmitter(self.Entity:GetPos())
end

function EFFECT:Think()
	if RealTime() > self.Time then
		self.Emitter:Finish()
		return false
	end
	return true
end

function EFFECT:Render()
	self.Entity:DrawModel()
	if self.Entity:GetVelocity():Length() > 20 then
		//local emitter = ParticleEmitter(self.Entity:GetPos())
		local particle = self.Emitter:Add("effects/blood_core", self.Entity:GetPos())
			particle:SetVelocity(VectorRand() * 16)
			particle:SetDieTime(0.6)
			particle:SetStartAlpha(255)
			particle:SetStartSize(18)
			particle:SetEndSize(8)
			particle:SetRoll(180)
			particle:SetColor(Color(255, 0, 0))
			particle:SetLighting(true)
	end
end
