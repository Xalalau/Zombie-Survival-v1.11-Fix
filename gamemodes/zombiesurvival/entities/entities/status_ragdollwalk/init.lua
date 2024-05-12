AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:PlayerSet(pPlayer, bExists)
	pPlayer.KnockedDown = true
	if not bExists then
		pPlayer:CreateRagdoll()
	end
end

function ENT:OnRemove()
	local parent = self:GetParent()
	if parent:IsValid() then
		parent.KnockedDown = nil

		if parent:Alive() then
			local rag = parent:GetRagdollEntity()
			if rag and rag:IsValid() then
				rag:Remove()
			end
		end
	end
end
