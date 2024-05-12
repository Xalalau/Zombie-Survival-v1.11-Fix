include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-40, -40, -18), Vector(40, 40, 90))

	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(40, 50)
	self.NextEmit = 0
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:DrawTranslucent()
	if self.NextEmit < CurTime() then
		self.NextEmit = CurTime() + 0.15
		local owner = self:GetOwner()
		if owner ~= LocalPlayer() and owner:IsValid() then
			local particle = self.Emitter:Add("particle/smokestack", owner:GetPos() + Vector(0,0,32))
			particle:SetVelocity(owner:GetVelocity())
			particle:SetDieTime(math.Rand(0.9, 1.15))
			particle:SetStartAlpha(220)
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(30, 44))
			particle:SetEndSize(20)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1))
			particle:SetGravity(Vector(0,0,125))
			particle:SetCollide(true)
			particle:SetAirResistance(12)
			particle:SetColor(0, 200, 0)
		end
	end
end
