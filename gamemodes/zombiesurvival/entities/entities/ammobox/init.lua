AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetUseType(SIMPLY_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(true)
		phys:Wake()
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end

function ENT:Think()
	if self.GaveAmmo then self:Remove() end
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() and activator:Team() == TEAM_HUMAN and activator:Alive() and self.AmmoType and not self.GaveAmmo then
		self.GaveAmmo = true
		activator:GiveAmmo(AMMOAMOUNTS[self.AmmoType] or 12, self.AmmoType)
	end
end
