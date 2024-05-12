AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 7

	self:DrawShadow(false)
	self:PhysicsInitSphere(10)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(4)
		phys:EnableMotion(true)
		phys:Wake()
	end
end

function ENT:Think()
	if self.DieTime < CurTime() then
		if self.HitData then
			local data = self.HitData

			local hitent = data.HitEntity
			if hitent and hitent:IsValid() then
				local owner = self:GetOwner()
				if owner:IsValid() then
					hitent:TakeDamage(5, owner, self)
				else
					hitent:TakeDamage(5, self, self)
				end
			end

			self.HitData = nil
		end

		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end

	self.HitData = data
	self.DieTime = 0

	local effectdata = EffectData()
		effectdata:SetOrigin(data.HitPos)
		effectdata:SetNormal(data.HitNormal)
	util.Effect("pukehit", effectdata)

	self:NextThink(CurTime())
	return true
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
