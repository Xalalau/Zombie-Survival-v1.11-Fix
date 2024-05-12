include("shared.lua")

function ENT:Initialize()
	--self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 84))
	if file.Exists("../sound/ambient/music/looping_radio_mix.wav") then
		self.AmbientSound = CreateSound(self, "ambient/music/looping_radio_mix.wav")
	else
		self.AmbientSound = CreateSound(self, "ambient/machines/combine_terminal_loop1.wav")
	end
end

function ENT:OnRemove()
	self.AmbientSound:Stop()
end

function ENT:Think()
	self.AmbientSound:PlayEx(0.39, 100 + math.sin(RealTime()))
end

function ENT:DrawTranslucent()
	if DISPLAYHATS then
	local owner = self:GetOwner()
	if not owner:IsValid() or owner == MySelf and not NOX_VIEW and owner:Alive() then return end

	local rag = owner:GetRagdollEntity()
	if rag then
		owner = rag
	elseif not owner:Alive() then return end

	self:SetModelScale(Vector(0.5, 0.5, 0.5))

	local boneindex = owner:LookupBone("ValveBiped.Bip01_L_Hand")
	if boneindex then
		local pos, ang = owner:GetBonePosition(boneindex)
		if pos then
			local r,g,b,a = owner:GetColor()
			self:SetColor(r,g,b,math.max(1,a))
			self:SetPos(pos + ang:Forward() * 13)
			ang:RotateAroundAxis(ang:Up(), 90)
			ang:RotateAroundAxis(ang:Forward(), -90)
			self:SetAngles(ang)
			self:DrawModel()
			return
		end
	end
	end
end
