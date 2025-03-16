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

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CurTime() < self:GetNetworkedFloat("LastShootTime", -100) + self.Primary.Delay then return end

	local trace = self:GetOwner():TraceLine(62)

	if trace.Hit then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			util.Decal("Blood", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end
	end

	self:SetNetworkedFloat("LastShootTime", CurTime())
end

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

function SWEP:PrimaryAttack()
	local owner = self:GetOwner()
	owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", x + wide * 0.5, y + tall * 0.5, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur2 + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmallAA", XNameBlur + x + wide * 0.5, YNameBlur + y + tall * 0.5, color_blu1, TEXT_ALIGN_CENTER)
end
