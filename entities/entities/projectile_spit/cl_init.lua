include("shared.lua")

function ENT:Draw()
	self:SetColor(Color(0, 255, 0, 255))
	self:DrawModel()
end

function ENT:Initialize()
end

function ENT:Think()
	local pos = self:GetPos()
	local emitter = ParticleEmitter(pos)
		local particle = emitter:Add("sprites/light_glow02_add", pos)
			particle:SetVelocity(Vector(0,0,0))
			particle:SetDieTime(0.5)
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(30)
			particle:SetStartSize(math.Rand(4, 8))
			particle:SetEndSize(0)
			particle:SetRoll(math.Rand(-0.2, 0.2))
			particle:SetColor(0, 255, 0)
	emitter:Finish()
end

function ENT:OnRemove()
end
