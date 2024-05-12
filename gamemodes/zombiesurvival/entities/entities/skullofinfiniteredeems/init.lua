AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Gibs/AGIBS.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	//self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
		phys:SetMass(500)
		phys:SetMaterial("metal")
	end
end

function ENT:Think()
end

function ENT:PhysicsCollide(data, phys)
end

function ENT:Touch(ent)
	if ent:IsValid() and ent:IsPlayer() then
		if ent:Team() ~= TEAM_HUMAN then
			ent:Redeem()
		end

		INFINITEREDEEMS = ent

		local sendlua = [[InfRed("]]..ent:Name()..[[")]]
		for _, pl in pairs(player.GetAll()) do
			pl:SendLua(sendlua)
		end

		function self:Think() self:Remove() end
		function self:Touch() end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
