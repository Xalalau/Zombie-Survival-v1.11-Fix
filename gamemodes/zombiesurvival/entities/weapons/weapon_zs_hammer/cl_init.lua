include("shared.lua")

SWEP.PrintName = "Carpenter's Hammer"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 75
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Slot = 0
SWEP.SlotPos = 2

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Think()
end

function SWEP:DrawHUD()
	surface.SetFont("HUDFontSmallAA")
	local nails = self:Clip1()
	local TEXW, TEXH = surface.GetTextSize("Nails: "..nails)
	local nTEXW, nTEXH = surface.GetTextSize("Right click on an object to nail it to something behind that spot.")

	draw.RoundedBox(8, w - nTEXW - 32, h - nTEXH * 3 - 8, nTEXW + 16, nTEXH * 2 + 16, color_black_alpha180)

	if 0 < nails then
		draw.DrawText("Nails: "..nails, "HUDFontSmallAA", w - nTEXW * 0.5 - 24, h - nTEXH * 3, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
	else
		draw.DrawText("Nails: 0", "HUDFontSmallAA", w - nTEXW * 0.5 - 24, h - nTEXH * 3, COLOR_RED, TEXT_ALIGN_CENTER)
	end

	draw.DrawText("Right click on an object to nail it to something behind that spot.", "HUDFontSmallAA", w - nTEXW * 0.5 - 24, h - nTEXH * 2, COLOR_LIMEGREEN, TEXT_ALIGN_CENTER)
end

function SWEP:HUDShouldDraw(name)
	return name ~= "CHudHealth" and name ~= "CHudBattery" and name ~= "CHudSecondaryAmmo" and name ~= "CHudAmmo"
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
end

local function StabCallback(attacker, trace, dmginfo)
	if trace.Hit and trace.HitPos:Distance(trace.StartPos) <= 62 then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			util.Decal("Impact.Flesh", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			util.Decal("Impact.Concrete", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end

		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_HITCENTER)

		local ent = trace.Entity
		if ent:IsValid() and trace.HitPos:Distance(trace.StartPos) <= 62 then
			return {damage = true, effects = false}
		end
	else
		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_MISSCENTER)
	end

	return {effects = false, damage = false}
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

		self.Owner:SetAnimation(PLAYER_ATTACK1)

		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force = 5
		bullet.Damage = self.Primary.Damage
		bullet.HullSize = 1.75
		bullet.Callback = StabCallback
		self.Owner:FireBullets(bullet)
	end
end
