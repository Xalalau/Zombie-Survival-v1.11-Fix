if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
end

if CLIENT then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 75
	SWEP.ViewModelFlip		= true
	SWEP.CSMuzzleFlashes	= true

	surface.CreateFont("csd", ScreenScale(30), 500, true, true, "CSKillIcons")
	surface.CreateFont("csd", ScreenScale(60), 500, true, true, "CSSelectIcons")
end

SWEP.Author			= "JetBoom"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.Sound			= Sound("Weapon_AK47.Single")
SWEP.Primary.Recoil			= 1.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.02
SWEP.Primary.Delay			= 0.15

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()
	if SERVER then
		self:SetWeaponHoldType(self.HoldType)
	end
end

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Think()	
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end

	self.Weapon:EmitSound(self.Primary.Sound)
	self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
	self:TakePrimaryAmmo(1)
	self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0))

	if CLIENT then
		self.Weapon:SetNetworkedFloat("LastShootTime", CurTime())
	end
end

function SWEP:ZSShootBullet(dmg, numbul, cone)
	local bullet = {}
	bullet.Num 		= numbul
	bullet.Src 		= self.Owner:GetShootPos()
	bullet.Dir 		= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone, cone, 0)
	bullet.Tracer	= 1
	bullet.Force	= math.ceil(dmg*0.4)
	bullet.Damage	= dmg
	bullet.AmmoType = "Pistol"
	bullet.TracerName 	= "AR2Tracer"

	self.Owner:FireBullets(bullet)
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	-- I hate the custom recoil. It also conflicts with the anti-aimbot.
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.PrintName, "HUDFontSmall", x + wide/2, y + tall/2, COLOR_RED, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmall", XNameBlur2 + x + wide/2, YNameBlur + y + tall/2, color_blur1, TEXT_ALIGN_CENTER)
	draw.SimpleText(self.PrintName, "HUDFontSmall", XNameBlur + x + wide/2, YNameBlur + y + tall/2, color_blu1, TEXT_ALIGN_CENTER)
end

function SWEP:GetViewModelPosition(pos, ang)
	return pos, ang
end

SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()
	if self.NextSecondaryAttack > CurTime() then return end

	self.NextSecondaryAttack = CurTime() + 0.3
end
