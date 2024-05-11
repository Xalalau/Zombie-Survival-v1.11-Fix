if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "rpg"
end

if CLIENT then
	SWEP.PrintName = "'Tiny' Slug Rifle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_slugrifle", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.Weight = 6
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

//SWEP.Primary.Sound = Sound("Weapon_AWP.Single")
SWEP.Primary.Sound = Sound("weapons/awp/awp1.wav")
SWEP.Primary.Recoil = 5.0
SWEP.Primary.Damage = 92
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 2
SWEP.Primary.Delay = 1.5
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.ReloadDelay = 1.5
SWEP.Primary.Cone = 0.04
SWEP.ConeMoving = 0.16
SWEP.ConeCrouching = 0

SWEP.WalkSpeed = 150

SWEP.NextReload = 0
function SWEP:Reload()
	if CurTime() < self.NextReload then return end
	self.NextReload = CurTime() + self.Primary.Delay * 2
	
	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Weapon:SetNetworkedBool( "reloading", true )
		self.Weapon:DefaultReload( ACT_VM_RELOAD )
		timer.Simple(0.25, self.Weapon.SendWeaponAnim, self.Weapon, ACT_SHOTGUN_RELOAD_FINISH)
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end
