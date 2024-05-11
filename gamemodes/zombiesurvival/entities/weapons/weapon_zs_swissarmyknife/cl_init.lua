include("shared.lua")

SWEP.PrintName = "Swiss Army Knife"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.IconLetter = "j"
killicon.AddFont("weapon_zs_swissarmyknife", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255))

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
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmall", x + wide/2, y + tall/2, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmall", XNameBlur2 + x + wide/2, YNameBlur + y + tall/2, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmall", XNameBlur + x + wide/2, YNameBlur + y + tall/2, color_blu1, TEXT_ALIGN_CENTER)
end
