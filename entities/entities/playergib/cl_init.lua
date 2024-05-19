include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if self:GetVelocity():Length() > 20 then
		local particle = self.Emitter:Add("effects/blood_core", self:GetPos())
		particle:SetVelocity(VectorRand() * 16)
		particle:SetDieTime(0.6)
		particle:SetStartAlpha(255)
		particle:SetStartSize(18)
		particle:SetEndSize(8)
		particle:SetRoll(180)
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)
	end
end

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
end

function ENT:Think()
end

function ENT:OnRemove()
	self.Emitter:Finish()
end
