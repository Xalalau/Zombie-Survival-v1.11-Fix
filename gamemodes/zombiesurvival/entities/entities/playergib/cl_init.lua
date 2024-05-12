include("shared.lua")

function ENT:Draw()
	local scale = self:GetSkin()
	self:DrawModel()

	if 20 < self:GetVelocity():Length() then
		local particle = self.Emitter:Add("noxctf/sprite_bloodspray"..math.random(1,8), self:GetPos())
		particle:SetVelocity(VectorRand():Normalize() * math.Rand(8, 16))
		particle:SetDieTime(0.6)
		particle:SetStartAlpha(230)
		particle:SetEndAlpha(230)
		particle:SetStartSize(10)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 360))
		particle:SetRollDelta(math.Rand(-25, 25))
		particle:SetColor(255, 0, 0)
		particle:SetLighting(true)
	end
end

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	self.Emitter:Finish()
end
