include("shared.lua")

SWEP.PrintName = "Headcrab"
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

	if wep:GetClass() ~= "weapon_zs_headcrab" then return end

	local owner = wep:GetOwner()
	local vStart = owner:GetPos()
	local tr = {}
	local ang = wep:GetForward()
	--ang.y = 0

	tr.start = vStart
	tr.endpos = vStart + ang * 35 + Vector(0, 0, 10)
	tr.filter = owner
	local trace = util.TraceLine(tr)
	local ent = trace.Entity

 render.DrawLine(tr.start, tr.endpos, Color(255, 0, 0))
	if IsValid(ent) then
		print("Detected", ent)
	end

	render.SetColorMaterial()

	local updown = owner:GetForward().z
	local aimvectormultilier
	if updown > 0.25 then
		updown = Vector(0, 0, owner:GetForward().z * 47)
		aimvectormultilier = 1
	else
		updown = Vector(0, 0, owner:GetForward().z * 10)
		aimvectormultilier = 10
	end

	render.DrawSphere(owner:GetPos() + Vector(0,0,15) + owner:GetAimVector() * aimvectormultilier + updown, 10, 30, 30, Color(0, 175, 175, 100))
end)
--]]