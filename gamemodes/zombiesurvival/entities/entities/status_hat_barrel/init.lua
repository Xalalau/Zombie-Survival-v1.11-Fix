AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.NoRemoveOnDeath = true

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_c17/oildrum001_explosive.mdl")
end

function ENT:Think()
end
