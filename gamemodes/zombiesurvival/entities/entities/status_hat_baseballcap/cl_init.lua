include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))
end

function ENT:DrawTranslucent()
	if DISPLAYHATS then
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not NOX_VIEW and owner:Alive() then return end

	if owner:GetRagdollEntity() then
		owner = owner:GetRagdollEntity()
	elseif not owner:Alive() then return end

	local boneindex = owner:LookupBone("ValveBiped.Bip01_Head1")
	if boneindex then
		local pos, ang = owner:GetBonePosition(boneindex)
		if pos and pos ~= owner:GetPos() then
			local r,g,b,a = owner:GetColor()
			self:SetColor(r,g,b,math.max(1,a))
			self:SetPos(pos + ang:Forward() * 5.2 + ang:Right() * -2)
			ang:RotateAroundAxis(ang:Up(), 20)
			ang:RotateAroundAxis(ang:Right(), -90)
			self:SetAngles(ang)
			self:DrawModel()
			return
		end
	end

	local attach = owner:GetAttachment(owner:LookupAttachment("eyes"))
	if not attach then attach = owner:GetAttachment(owner:LookupAttachment("head")) end
	if attach then
		local r,g,b,a = owner:GetColor()
		self:SetColor(r,g,b,math.max(1,a))
		local ang = attach.Ang
		self:SetPos(attach.Pos + ang:Up() * 3 + ang:Forward() * -2.5)
		ang:RotateAroundAxis(ang:Up(), 270)
		self:SetAngles(ang)

		self:DrawModel()
	end
	end
end
