include("shared.lua")

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(48, 64)
end

function ENT:Think()
	local emitter = self.Emitter
	local pos = self:GetPos()
	emitter:SetPos(pos)

	local particle = emitter:Add("particles/smokey", pos)
	particle:SetVelocity(VectorRand():Normalize() * math.Rand(2, 14))
	particle:SetDieTime(math.Rand(0.6, 0.74))
	particle:SetStartAlpha(math.Rand(200, 220))
	particle:SetEndAlpha(0)
	particle:SetStartSize(1)
	particle:SetEndSize(math.Rand(8, 10))
	particle:SetRoll(math.Rand(-0.2, 0.2))
	particle:SetColor(50, 50, 50)
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

function ENT:Draw()
	self:DrawModel()
end
