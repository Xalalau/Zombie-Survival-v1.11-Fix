include("shared.lua")

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(36, 44)
end

function ENT:Think()
	self.Emitter:SetPos(self:GetPos())
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

local matPuke = Material("decals/Yblood1")
function ENT:Draw()
	render.SetMaterial(matPuke)
	local pos = self:GetPos()
	render.DrawSprite(pos, 32, 32, color_white)

	local particle = self.Emitter:Add("decals/Yblood"..math.random(1,6), pos + VectorRand():Normalize() * math.Rand(1, 4))
	particle:SetVelocity(VectorRand():Normalize() * math.Rand(1, 4))
	particle:SetDieTime(math.Rand(0.6, 0.9))
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	particle:SetStartSize(math.Rand(2, 5))
	particle:SetEndSize(0)
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-1, 1))
end
