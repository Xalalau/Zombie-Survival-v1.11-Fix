AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.KnockedDown = true
	pPlayer:Freeze(true)
	if pPlayer.m_DrawWorldModel then
		self.ResetWorldModel = true
		pPlayer:DrawWorldModel(false)
	end

	if pPlayer.m_DrawViewModel then
		self.ResetViewModel = true
		pPlayer:DrawViewModel(false)
	end

	self:SetNetworkedFloat("endtime", self.DieTime)
	if not bExists then
		pPlayer:CreateRagdoll()
	end
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent:Freeze(false)
		parent.KnockedDown = nil

		if parent:Alive() then
			if self.ResetViewModel then
				parent:DrawViewModel(true)
			end

			if self.ResetWorldModel then
				parent:DrawWorldModel(true)
			end

			local rag = parent:GetRagdollEntity()
			if rag and rag:IsValid() then
				rag:Remove()
			end
		end
	end
end
