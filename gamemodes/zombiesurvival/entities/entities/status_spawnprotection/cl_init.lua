include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-90, -90, -18), Vector(90, 90, 90))

	local owner = self:GetOwner()
	if owner:IsValid() then
		self.OldMaterial = owner:GetMaterial()
		owner:SetMaterial("models/flesh")
	end
end

function ENT:OnRemove()
	local owner = self:GetOwner()
	if owner:IsValid() then
		owner:SetMaterial(self.OldMaterial or "")
	end
end

function ENT:Think()
end

function ENT:Draw()
end
