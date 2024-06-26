include("shared.lua")

SWEP.PrintName = "'Aegis' Barricade Kit"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Slot = 4
SWEP.SlotPos = 5

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Think()
	if 0 < self:Clip1() then
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 32)
			effectdata:SetNormal(self:GetOwner():GetAimVector())
		util.Effect("barricadeghost", effectdata, true, true)
	end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide*0.5, y + tall*0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide*0.5, YNameBlur + y + tall*0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide*0.5, YNameBlur + y + tall*0.5, color_blu1, TEXT_ALIGN_CENTER)
end
