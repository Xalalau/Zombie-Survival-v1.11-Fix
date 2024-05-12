include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)

	self:GetOwner().BloodDye = self
	self:GetOwner().BloodDyeColor = self:GetSkin()
end

function ENT:OnRemove()
	self:GetOwner().BloodDye = nil
end
