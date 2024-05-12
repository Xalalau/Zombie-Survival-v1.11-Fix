function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ent = data:GetEntity()
	self.Entity:SetPos(pos)
	self.Entity:SetAngles(ent:GetAngles())
	WorldSound("ambient/explosions/exp3.wav", pos, 80, math.random(100, 110))
	self.DieTime = RealTime() + math.Rand(3.5, 4)
	self.Entity:SetModel(ent:GetModel())
	self.Entity:PhysicsInitSphere(8)
	self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:EnableGravity(false)
	end
	local tr = util.TraceLine({start = pos, endpos = pos + Vector(0,0,-64), mask = COLLISION_GROUP_WORLD})
	util.Decal("FadingScorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
end

function EFFECT:Think()
	local pos = self.Entity:GetPos()
	self.Entity:GetPhysicsObject():SetVelocityInstantaneous(Vector(0,0,300))
	if util.TraceLine({start = pos, endpos = pos + Vector(0,0,74), mask = COLLISION_GROUP_DEBRIS, filter = self.Entity}).HitWorld then
		self.DieTime = 0
	end
	if RealTime() >= self.DieTime then
		WorldSound("ambient/explosions/explode_"..math.random(2,5)..".wav", pos, 90, math.random(100, 110))
		local emitter = ParticleEmitter(pos)
			for i=1, math.random(200, 230) do			
				particle = emitter:Add("sprites/light_glow02_add", pos + VectorRand():Normalize() * 100)
				particle:SetVelocity(VectorRand():Normalize() * 700)
				particle:SetDieTime(math.Rand(2.75, 4.0))
				particle:SetStartAlpha(220)
				particle:SetEndAlpha(0)
				particle:SetStartSize(26)
				particle:SetEndSize(1)
				particle:SetRoll(math.Rand(-0.8, 0.8))
				particle:SetCollide(true)
				local rand = math.random(1, 3)
				if rand == 1 then
					particle:SetColor(255, 0, 0)
				elseif rand == 2 then
					particle:SetColor(255, 255, 255)
				elseif rand == 3 then
					particle:SetColor(30, 100, 255)
				end
				particle:SetBounce(0.9)
				particle:SetGravity(Vector(0,0,-400))
				particle:SetAirResistance(60)
			end
		emitter:Finish()
		return false
	end
	return true
end

function EFFECT:Render()
	self.Entity:DrawModel()
	local pos = self.Entity:GetPos()
	local emitter = ParticleEmitter(pos)
		for i=1, 4 do
			local particle = emitter:Add("effects/fire_embers"..math.random(1,3), pos)
			particle:SetVelocity(self.Entity:GetVelocity() * -0.4 + VectorRand():Normalize() * 20)
			particle:SetDieTime(0.3)
			particle:SetStartAlpha(150)
			particle:SetEndAlpha(60)
			particle:SetStartSize(math.Rand(10, 14))
			particle:SetEndSize(1)
			particle:SetRoll(math.random(0, 360))
		end
	emitter:Finish()
end
