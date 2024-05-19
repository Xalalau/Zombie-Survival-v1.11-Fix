include("shared.lua")

SWEP.PrintName = "Wraith"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 40
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

	timer.Simple(0.1, function() -- This avoids the last Think() overriding reder mode and colors here
		if vm and vm:IsValid() then
			vm:SetRenderMode(RENDERMODE_NORMAL)
			vm:SetColor(Color(255, 255, 255, 255))
		end		
	end)
end

function SWEP:Think()
	local ply = LocalPlayer()
	local vm = ply:GetViewModel()
	if vm and vm:IsValid() and ply:Health() > 0 then
		if vm:GetRenderMode() == RENDERMODE_NORMAL then
			vm:SetRenderMode(RENDERMODE_TRANSCOLOR) -- Hacky solution to keep the rendermode 1. Idk why it keeps resting - Xala
		end
		vm:SetColor(Color(20, 20, 20, math.max(15, math.min(ply:GetVelocity():Length(), 200))))
	end
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
end
