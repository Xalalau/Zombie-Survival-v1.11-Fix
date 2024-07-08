AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Deployed = false

function SWEP:Deploy()
	self:GetOwner():DrawViewModel(false)
	self:GetOwner():DrawWorldModel(false)

	if self.Deployed then return end
	self.Deployed = true

	local effectdata = EffectData()
		effectdata:SetEntity(self:GetOwner())
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetVelocity():GetNormalized())
	util.Effect("chemzombieambient", effectdata)
end
