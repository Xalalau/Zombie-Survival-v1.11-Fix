include("shared.lua")

SWEP.PrintName = "Grenade"
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.CSMuzzleFlashes = false

SWEP.Slot = 4
SWEP.SlotPos = 6

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
end

function SWEP:GetViewModelPosition(pos, ang)
	if self.Owner:GetNetworkedBool("IsHolding") then
		return pos + ang:Forward() * -256, ang
	end

	return pos, ang
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	return false
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	local pn = self.PrintName
	draw.SimpleText(pn, "HUDFontSmallAA", x + wide*0.5, y + tall*0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(pn, "HUDFontSmallAA", XNameBlur2 + x + wide*0.5, YNameBlur + y + tall*0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(pn, "HUDFontSmallAA", XNameBlur + x + wide*0.5, YNameBlur + y + tall*0.5, color_blu1, TEXT_ALIGN_CENTER)
end
