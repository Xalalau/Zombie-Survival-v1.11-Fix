include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 84))
end

--local matGlow = Material("sprites/light_glow02_add")
local matGlow = Material("sprites/glow04_noz")
function ENT:DrawTranslucent()
	if DISPLAYHATS then
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not NOX_VIEW and owner:Alive() then return end

	if owner:GetRagdollEntity() then
		owner = owner:GetRagdollEntity()
	elseif not owner:Alive() then return end

	local r,g,b,a = owner:GetColor()
	if a < 200 then return end

	local coltouse = COLOR_CYAN
	if r+g+b ~= 765 then
		coltouse = Color(r, g, b, a)
	end

	local realtime = RealTime() * 5

	render.SetMaterial(matGlow)
	for i=0, 25, 2 do
		local bone = owner:GetBoneMatrix(i)
		if bone then
			local pos2 = bone:GetTranslation()
			render.DrawSprite(pos2, 15, 15, color_white)
			render.DrawSprite(pos2, 22 + math.Rand(5, 7), 22 + math.Rand(5, 7), coltouse)
		end
	end
	end
end
