AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self.DieTime = self.DieTime or 0
end

function ENT:Think()
	local owner = self:GetOwner()
	if self.DieTime < CurTime() or not owner:Alive() or owner:Team() ~= TEAM_UNDEAD then
		self:Remove()
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:GodDisable()
		if owner:Alive() then
			GAMEMODE:SetPlayerSpeed(owner, owner.ClassTable.Speed)
		end
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
