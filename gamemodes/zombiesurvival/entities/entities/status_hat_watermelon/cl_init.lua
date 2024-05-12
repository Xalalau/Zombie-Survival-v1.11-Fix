include("shared.lua")

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 84))
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
			self:SetPos(pos + ang:Forward() * 5)
			ang:RotateAroundAxis(ang:Forward(), 90)
			ang:RotateAroundAxis(ang:Right(), 90)
			self:SetAngles(ang)
			self:SetModelScale(Vector(1.2, 1.2, 1.2))
			self:DrawModel()
			return
		end
	end

	local attach = owner:GetAttachment(owner:LookupAttachment("eyes"))
	if not attach then attach = owner:GetAttachment(owner:LookupAttachment("head")) end
	if attach then
		local r,g,b,a = owner:GetColor()
		self:SetColor(r,g,b,math.max(1,a))
		self:SetPos(attach.Pos)
		self:SetAngles(attach.Ang)
		self:SetColor(owner:GetColor())
		self:SetModelScale(Vector(1.2, 1.2, 1.2))
		self:DrawModel()
	end
	end
end
