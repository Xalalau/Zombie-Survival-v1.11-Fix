if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "shotgun"
end

if CLIENT then
	SWEP.PrintName = "Sweeper SG"
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.IconLetter = "0"
	killicon.AddFont("weapon_zs_sweepershotgun", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_m3super90.mdl"


SWEP.Weight				= 10
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.ReloadDelay = 1.1

SWEP.Primary.Sound			= Sound("Weapon_M3.Single")
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 12
SWEP.Primary.NumShots		= 8
SWEP.Primary.Cone			= 0.28
SWEP.Primary.ClipSize		= 2
SWEP.Primary.Delay			= 0.9
SWEP.Primary.DefaultClip	= 20
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
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
