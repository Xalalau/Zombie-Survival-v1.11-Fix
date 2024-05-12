include("shared.lua")

function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos())
	self.Emitter:SetNearClip(60, 70)
	self.NextGas = 0
	self.NextSound = 0
end

function ENT:OnRemove()
	self.Emitter:Finish()
end

function ENT:Think()
	if self.NextSound <= CurTime() then
		self.NextSound = CurTime() + math.Rand(4, 6)

		if 0 < GAMEMODE:GetWave() and MySelf:IsValid() and MySelf:Team() == TEAM_HUMAN and MySelf:Alive() and MySelf:EyePos():Distance(self:GetPos()) < self:GetRadius() + 128 then
			surface.PlaySound("ambient/voices/cough"..math.random(1, 4)..".wav")
		end
	end
end

local matGlow = Material("sprites/glow04_noz")
local colGlow = Color(0, 180, 0, 220)
function ENT:Draw()
	local pos = self:GetPos()
	local radius = self:GetRadius()
	render.SetMaterial(matGlow)
	render.DrawSprite(pos + Vector(0, 0, radius * 0.5), radius + math.Rand(0, 80), radius + math.Rand(0, 80), colGlow)

	if CurTime() < self.NextGas then return end
	self.NextGas = CurTime() + math.Rand(2.25, 3.25)

	local particle = self.Emitter:Add("particles/smokey", pos + VectorRand():Normalize() * math.Rand(8, radius + 32))
	particle:SetVelocity(VectorRand():Normalize() * math.Rand(8, 32))
	particle:SetDieTime(math.Rand(3, 4))
	particle:SetStartAlpha(math.Rand(115, 145))
	particle:SetEndAlpha(0)
	particle:SetStartSize(8)
	particle:SetEndSize(radius * math.Rand(0.8, 1.2))
	particle:SetRoll(math.Rand(0, 360))
	particle:SetRollDelta(math.Rand(-2, 2))
	particle:SetColor(20, 200, 0)
	particle:SetCollide(true)
end
