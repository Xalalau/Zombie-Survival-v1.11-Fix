function EFFECT:Init(data)
	local Dir = data:GetNormal()

	Dir.z = math.max(-32, Dir.z) * 2.5
	//self.Entity:PhysicsInitSphere(4)
	local max = Vector(3,3,3)
	local min = max * -1
	self.Entity:PhysicsInitBox(min,max)
	self.Entity:SetCollisionBounds(min,max) 
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		// phys:ApplyForceCenter(Dir * math.random(200, 2500))
		phys:ApplyForceCenter(Dir * math.random(10000, 65000))
	end
	self.Living = RealTime() + 4
end

function EFFECT:Think()
	local tr = util.TraceLine({start = self.Entity:GetPos(), endpos = self.Entity:GetPos() + self.Entity:GetVelocity():GetNormalized() * 16, mask = MASK_NPCWORLDSTATIC})
	if tr.Hit then
		self.Living = -5
		local emitter = ParticleEmitter(self.Entity:GetPos())
			local particle = emitter:Add("effects/fire_cloud1", self.Entity:GetPos())
			particle:SetDieTime(0.75)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(20)
			particle:SetStartSize(13)
			particle:SetEndSize(2)
			particle:SetRoll(180)
			particle:SetColor(Color(255, 255, 255))
		emitter:Finish()
	end
	return RealTime() < self.Living
end

function EFFECT:Render()
	local emitter = ParticleEmitter(self.Entity:GetPos())
		local particle = emitter:Add("effects/fire_cloud1", self.Entity:GetPos() + VectorRand() * 4)
		particle:SetDieTime(0.3)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(200)
		particle:SetStartSize(5)
		particle:SetEndSize(1)
		particle:SetRoll(180)
		particle:SetColor(Color(255, 220, 100))
	emitter:Finish()
end
