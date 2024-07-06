include("shared.lua")

SWEP.PrintName = "Fast Zombie"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModelFOV = 70
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

function SWEP:Think()
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
end

--[[
hook.Add("PostDrawTranslucentRenderables", "TestDamage", function()
	local wep = LocalPlayer():GetActiveWeapon()

	if wep:GetClass() ~= "weapon_zs_fastzombie" then return end

	local ent
	local owner = wep:GetOwner()
	local updown = owner:GetForward().z
	local aimvectormultilier
	if updown > 0.8 then
		updown = Vector(0, 0, owner:GetForward().z * 20)
		aimvectormultilier = 5
	elseif updown < -0.85 then
		updown = Vector(0, 0, owner:GetForward().z * 55)
		aimvectormultilier = 5
	else
		updown = Vector(0, 0, 0)
		aimvectormultilier = 35
	end

	render.DrawSphere(owner:GetPos() + Vector(0, 0, 55) + owner:GetAimVector() * aimvectormultilier + updown, 10, 30, 30, Color(0, 175, 175, 100))
end)
--]]