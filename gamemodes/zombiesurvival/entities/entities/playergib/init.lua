AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.DieTime = CurTime() + math.Rand(20, 35)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:ApplyForceCenter(VectorRand() * math.Rand(2000, 5000))
	end
end

function ENT:Think()
	if self.DieTime < CurTime() then
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
end

function ENT:StartTouch(ent)
	if self.DieTime ~= -10 and ent:IsPlayer() and ent:Alive() and ent:Team() == TEAM_UNDEAD and ent:Health() < ent.ClassTable.Health then
		self.DieTime = -10

		local maxhealth = ent.ClassTable.Health
		ent:SetHealth(math.min(maxhealth, ent:Health() + maxhealth * 0.05))

		self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetMagnitude(math.random(1, 5))
			effectdata:SetEntity(self)
			effectdata:SetScale(self.BType)
		util.Effect("bloodstream", effectdata)
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
