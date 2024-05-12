AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.NoRemoveOnDeath = true

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props/cs_office/Snowman_hat.mdl")
end

function ENT:Think()
end
