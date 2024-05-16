include("shared.lua")

SWEP.PrintName = "Wraith"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:Deploy()
end

function SWEP:Holster()
	local vm = LocalPlayer():GetViewModel()
	if vm and vm:IsValid() then
		vm:SetColor(Color(255, 255, 255, 255))
	end
end

function SWEP:Think()
	local ply = LocalPlayer()
	local vm = ply:GetViewModel()
	if vm and vm:IsValid() then
		vm:SetColor(Color(20, 20, 20, math.max(15, math.min(ply:GetVelocity():Length(), 200))))
	end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
end
