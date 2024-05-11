local USA = {}
USA[1] = Color(255, 50, 50)
USA[2] = color_white
USA[3] = Color(20, 20, 255)

function EFFECT:Init(data)
	local Dir = data:GetNormal()
	local Speed = data:GetMagnitude() or 600
	-- Speed = Speed * 100
	Dir.z = math.max(Dir.z, Dir.z * -1)
	if Dir.z > 0.5 then
		Dir.z = Dir.z - 0.3
	end
	Dir = Dir + VectorRand() * 0.03
	self.Entity:PhysicsInitSphere(4)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(false)
		phys:ApplyForceCenter(Dir * Speed)
	end
	self.Living = true

	self.ColorChoice = USA[math.random(1,3)]
end

function EFFECT:Think()
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetVelocity(phys:GetVelocity() + Vector(0,0,-40))
	end
	local tr = util.TraceLine({start = self.Entity:GetPos(), endpos = self.Entity:GetPos() + self.Entity:GetVelocity():Normalize() * 16, mask = MASK_NPCWORLDSTATIC})
	if tr.Hit then
		tr.HitPos:Add(tr.HitNormal * 2)
		local effectdata = EffectData()
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetNormal(tr.HitNormal)
		util.Effect("bloodsplash", effectdata)
		self.Living = false
	end
	return self.Living
end

function EFFECT:Render()
	local emitter = ParticleEmitter(self.Entity:GetPos())
		//local particle = emitter:Add("effects/blood_core", self.Entity:GetPos())
		local particle = emitter:Add("particle/smokestack", self.Entity:GetPos())
		particle:SetVelocity(Vector(0,0,-16))
		particle:SetDieTime(0.9)
		particle:SetStartAlpha(255)
		particle:SetStartSize(15)
		particle:SetEndSize(5)
		particle:SetRoll(180)
		//particle:SetColor(120, 10, 10)
		local cho = self.ColorChoice
		particle:SetColor(cho.r, cho.g, cho.b)
	emitter:Finish()
end
