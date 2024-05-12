include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 84))
	self.Rotation = math.Rand(0, 180)
end

local matHalo = Material("effects/select_ring")
function ENT:DrawTranslucent()
	if DISPLAYHATS then
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not NOX_VIEW and owner:Alive() then return end

	if owner:GetRagdollEntity() then
		owner = owner:GetRagdollEntity()
	elseif not owner:Alive() then return end

	local attach = owner:GetAttachment(owner:LookupAttachment("eyes"))
	if not attach then attach = owner:GetAttachment(owner:LookupAttachment("head")) end

	local pos
	if attach then
		pos = attach.Pos + Vector(0, 0, 12)
	else
		pos = owner:GetPos() + Vector(0, 0, 32)
	end

	render.SetMaterial(matHalo)
	local rot = self.Rotation
	self.Rotation = rot + FrameTime() * 7
	if 360 < self.Rotation then self.Rotation = self.Rotation - 360 end
	render.DrawQuadEasy(pos, Vector(math.sin(rot), math.cos(rot), 5):Normalize(), 24, 24, Color(owner:GetColor()))
	end
end
