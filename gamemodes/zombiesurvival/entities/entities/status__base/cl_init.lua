include("shared.lua")

function ENT:Draw()
end

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 80))
end

function ENT:Think()
end

function ENT:OnRemove()
end
