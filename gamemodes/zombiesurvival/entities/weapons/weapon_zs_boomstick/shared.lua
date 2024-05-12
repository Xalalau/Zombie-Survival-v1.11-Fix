if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "shotgun"
end

if CLIENT then
	SWEP.PrintName = "Boom Stick"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_shotgun.mdl"
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"

SWEP.Weight = 10
SWEP.ReloadDelay = 0.4

util.PrecacheSound("weapons/shotgun/shotgun_dbl_fire.wav")
SWEP.PrimarySound = "weapons/shotgun/shotgun_dbl_fire.wav"
SWEP.PrimaryRecoil = 12.5
SWEP.PrimaryDamage = 25
SWEP.PrimaryNumShots = 12
SWEP.PrimaryDelay = 1.5

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 24
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"

SWEP.Cone = 0.215
SWEP.ConeCrouching = 0.215
SWEP.ConeMoving = 0.215
SWEP.ConeIron = 0.21
SWEP.ConeIronCrouching = 0.205

SWEP.WalkSpeed = 140

SWEP.reloadtimer = 0
SWEP.nextreloadfinish = 0

SWEP.IronSightsPos = Vector(-8.975, -5, 3.3)
SWEP.IronSightsAng = Vector(1, 0, 0)

function SWEP:Reload()
	if self.reloading then return end

	if self:GetNextReload() <= CurTime() and self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
		self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
		self.reloading = true
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
		self.Owner:SetAnimation(PLAYER_RELOAD)
		self:SetNextReload(CurTime() + self:SequenceDuration())
	end
end

function SWEP:Think()
	if self.reloading and self.reloadtimer < CurTime() then
		self.reloadtimer = CurTime() + self.ReloadDelay
		self:SendWeaponAnim(ACT_VM_RELOAD)

		self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
		self:SetClip1(self:Clip1() + 1)
		self:EmitSound("Weapon_Shotgun.Reload")

		if self.Primary.ClipSize <= self:Clip1() or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
			self.nextreloadfinish = CurTime() + self.ReloadDelay
			self.reloading = false
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
		end
	end

	local nextreloadfinish = self.nextreloadfinish
	if nextreloadfinish ~= 0 and nextreloadfinish < CurTime() then
		self:SendWeaponAnim(ACT_SHOTGUN_PUMP)
		self:EmitSound("Weapon_Shotgun.Special1")
		self.nextreloadfinish = 0
	end
end

if SERVER then
	function SWEP:PrimaryAttack()
		if self:CanPrimaryAttack() then
			self:SetNextPrimaryFire(CurTime() + self.PrimaryDelay)
			self:EmitSound(self.PrimarySound)

			self:ZSShootBullet(self.PrimaryDamage, self.PrimaryNumShots, self.Cone)

			self:TakePrimaryAmmo(2)
			self.Owner:ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.PrimaryRecoil, math.Rand(-0.1,0.1) * self.PrimaryRecoil, 0))

			self.Owner:SetVelocity(self.Owner:GetAimVector() * -160)
		end
	end
end

function SWEP:CanPrimaryAttack()
	if self.Owner:Team() == TEAM_UNDEAD then self.Owner:PrintMessage(HUD_PRINTCENTER, "Great Job!") self.Owner:Kill() return false end
	if self:Clip1() < 2 then
		self:EmitSound("Weapon_Shotgun.Empty")
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	if self.reloading then
		if self:Clip1() < 2 then
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		else
			self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_PUMP)
			self:EmitSound("Weapon_Shotgun.Special1")
		end
		self.reloading = false
		self:SetNextPrimaryFire(CurTime() + 0.25)
		return false
	end

	return self:GetNextPrimaryFire() <= CurTime()
end
