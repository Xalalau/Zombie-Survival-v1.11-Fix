EFFECT.Time = math.Rand(5, 10)

function EFFECT:Init(data)
	local modelid = data:GetMagnitude()
	/*local scale = data:GetScale()
	if scale == 2 then
		self.Entity:SetModel(HumanLegs[modelid])
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.Entity:SetCollisionBounds(Vector(-64 -64, -64), Vector(64, 64, 64))

		for x=0, self.Entity:GetPhysicsObjectCount( ) do
			local phys = self.Entity:GetPhysicsObjectNum(x)
			if phys:IsValid() then
				local objects = self.Entity:GetPhysicsObjectCount()
				for i=0, objects-1 do
					local physobject = self.Entity:GetPhysicsObjectNum(i)
					physobject:EnableMotion(true)
					physobject:Wake()
				end
				phys:EnableMotion(true)
				phys:Wake()
				phys:SetAngle(Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360)))
				phys:ApplyForceCenter(VectorRand() * math.Rand(50000, 400000))
			end
		end
	elseif scale == 3 then
		self.Entity:SetModel(HumanTorsos[modelid])
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.Entity:SetCollisionBounds(Vector(-64 -64, -64), Vector(64, 64, 64))
		for x=0, self.Entity:GetPhysicsObjectCount( ) do
			local phys = self.Entity:GetPhysicsObjectNum(x)
			if phys:IsValid() then
				local objects = self.Entity:GetPhysicsObjectCount()
				for i=0, objects-1 do
					local physobject = self.Entity:GetPhysicsObjectNum(i)
					physobject:EnableMotion(true)
					physobject:Wake()
				end
				phys:EnableMotion(true)
				phys:Wake()
				phys:SetAngle(Angle( math.Rand(0,360), math.Rand(0,360), math.Rand(0,360)))
				phys:ApplyForceCenter(VectorRand() * math.Rand(50000, 400000))
			end
		end
	else*/
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
			phys:ApplyForceCenter(VectorRand() * math.Rand(5000, 40000))
		end
	//end
	self.Time = 11
end

function EFFECT:Think()
	self.Time = self.Time - FrameTime()
	return self.Time > 0
end

function EFFECT:Render()
	self.Entity:DrawModel()
	if self.Entity:GetVelocity():Length() > 20 then
		local emitter = ParticleEmitter(self.Entity:GetPos())
			local particle = emitter:Add("effects/blood_core", self.Entity:GetPos())
			if particle then
				particle:SetVelocity(VectorRand() * 16)
				particle:SetDieTime(0.6)
				particle:SetStartAlpha(255)
				particle:SetStartSize(18)
				particle:SetEndSize(8)
				particle:SetRoll(180)
				particle:SetColor(75, 0, 0)
			end
		emitter:Finish()
	end
end
