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

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"

SWEP.Weight = 10
SWEP.ReloadDelay = 1.1

util.PrecacheSound("Weapon_M3.Single")
util.PrecacheSound("weapons/m3/m3-1.wav")

//SWEP.PrimarySound = "Weapon_M3.Single"
SWEP.PrimarySound = "weapons/m3/m3-1.wav"
SWEP.PrimaryRecoil = 3.5
SWEP.PrimaryDamage = 12
SWEP.PrimaryNumShots = 10
SWEP.PrimaryDelay = 0.9

SWEP.Primary.ClipSize = 3
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"

SWEP.Cone = 0.21
SWEP.ConeMoving = 0.22
SWEP.ConeCrouching = 0.2

SWEP.WalkSpeed = 140

SWEP.NextReload = 0
function SWEP:Reload()
	if CurTime() < self.NextReload then return end
	self.NextReload = CurTime() + self.PrimaryDelay * 2

	if self:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self:SetNetworkedBool( "reloading", true )
		self:DefaultReload( ACT_VM_RELOAD )
		timer.Simple(0.25, self.SendWeaponAnim, self, ACT_SHOTGUN_RELOAD_FINISH)
		self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
	end
end

if CLIENT then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
			self:EmitSound(self.PrimarySound)
			if self.Owner:GetVelocity():Length() > 25 then
				self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeMoving)
			else
				if self.Owner:Crouching() then
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeCrouching)
				else
					self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.Cone)
				end
			end
			self:TakePrimaryAmmo(1)
			self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.PrimaryRecoil, math.Rand(-0.1,0.1) *self.PrimaryRecoil, 0))

			self:SetNetworkedFloat("LastShootTime", CurTime())
		end
	end
end

if SERVER then
	function SWEP:PrimaryAttack()
		if not self:CanPrimaryAttack() then return end

		self:EmitSound(self.PrimarySound)
		if self.Owner:GetVelocity():Length() > 25 then
			self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeMoving)
		else
			if self.Owner:Crouching() then
				self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.ConeCrouching)
			else
				self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.Cone)
			end
		end
		self:TakePrimaryAmmo(1)
		self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.PrimaryRecoil, math.Rand(-0.1,0.1) *self.PrimaryRecoil, 0))
	end
end

function SWEP:CanPrimaryAttack()
	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self:GetNetworkedBool("reloading", false) then
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		self:SetNetworkedBool("reloading", false)
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return true
end
