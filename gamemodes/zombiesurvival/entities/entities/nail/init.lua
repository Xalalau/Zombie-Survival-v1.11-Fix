AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/crossbow_bolt.mdl")
	self.Heal = 225
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
