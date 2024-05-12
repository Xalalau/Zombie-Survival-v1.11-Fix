if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "rpg"
end

if CLIENT then
	SWEP.PrintName = "'Tiny' Slug Rifle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 4
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.Weight = 6
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.PrimarySound = Sound("Weapon_AWP.Single")
SWEP.PrimaryRecoil = 14.0
SWEP.PrimaryDamage = 92
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 1.5
SWEP.ReloadDelay = 2

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"

SWEP.Cone = 0.1
SWEP.ConeMoving = 0.12
SWEP.ConeCrouching = 0.02
SWEP.ConeIron = 0.05
SWEP.ConeIronCrouching = 0.005

SWEP.IronSightsPos = Vector(5.12, -3.2, 2.15)
SWEP.IronSightsAng = Vector(-0.15, 0.6, 0)

SWEP.WalkSpeed = 150

SWEP.NextReload = 0
function SWEP:Reload()
	if self.NextReload < CurTime() then
		self.NextReload = CurTime() + self.ReloadDelay

		if self:Clip1() < self.Primary.ClipSize and 0 < self.Owner:GetAmmoCount(self.Primary.Ammo) then
			self:SetNetworkedBool("reloading", true)
			self:DefaultReload(ACT_VM_RELOAD)
			timer.Simple(0.25, self.SendWeaponAnim, self, ACT_SHOTGUN_RELOAD_FINISH)
			self:SetNextPrimaryFire(CurTime() + self.ReloadDelay)
		end
	end
end
