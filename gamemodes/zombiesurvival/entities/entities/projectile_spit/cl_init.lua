include("shared.lua")

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(20, 30)
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

function ENT:Draw()
	self:SetColor(0, 255, 0, 255)
	self:DrawModel()

	local particle = self.Emitter:Add("sprites/light_glow02_add", self:GetPos())
	particle:SetDieTime(0.5)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(30)
	particle:SetStartSize(math.Rand(4, 8))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(-0.2, 0.2))
	particle:SetColor(0, 255, 0)
end
