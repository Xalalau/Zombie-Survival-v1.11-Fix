AddCSLuaFile("shared.lua")

SWEP.Author = "JetBoom & Xalalau"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = false
end

if CLIENT then
	SWEP.ViewModelFOV = 70
	SWEP.DrawAmmo = false	
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFlip = false
	SWEP.CSMuzzleFlashes = false
end

function SWEP:Think()
end

function SWEP:Reload()
	return false
end

if CLIENT then
	function SWEP:CanPrimaryAttack()
		return false
	end
	
	function SWEP:CanSecondaryAttack()
		return false
	end

	function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
		draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
	end
end