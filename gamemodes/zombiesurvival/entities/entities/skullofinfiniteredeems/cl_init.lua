include("shared.lua")

function ENT:Initialize()
end

function ENT:Think()
end

function ENT:OnRemove()
end

local colOrange = Color(255, 200, 0)
local matGlow = Material("sprites/light_glow02_add_noz")

function ENT:Draw()
	self:SetColor(255, 200, 0, 255)
	self:DrawModel()

	render.SetMaterial(matGlow)
	local size = math.sin(RealTime() * 5) * 8 + 22
	local pos = self:GetPos()
	render.DrawSprite(pos + (MySelf:EyePos() - pos):Normalize() * 4, size, size, colCyan)

	local emitter = ParticleEmitter(pos)
	for i=1, math.random(3, 5) do
		local particle = emitter:Add("sprites/light_glow02_add", pos + VectorRand():Normalize() * math.Rand(2, 4))
		particle:SetVelocity(Vector(0,0,0))
		particle:SetDieTime(0.5)
		particle:SetStartAlpha(255)
		particle:SetEndAlpha(30)
		particle:SetStartSize(math.Rand(4, 8))
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(-0.2, 0.2))
		particle:SetColor(255, 200, 0)
	end
	emitter:Finish()
end

local infname = "Nobody"

local function InfRedHook()
	draw.SimpleTextShadow("Skull of Infinite Redeems held by: "..infname, "ScoreboardSub", w * 0.5, h * 0.9, COLOR_ORANGE, color_black, TEXT_ALIGN_CENTER)
end

function InfRed(name)
	infname = name
	MySelf:ChatPrint(name.." picked up the Skull of Infinite Redeems!")
	surface.PlaySound("npc/manhack/bat_away.wav")
	hook.Add("HUDPaint", "InfRed", InfRedHook)
end
