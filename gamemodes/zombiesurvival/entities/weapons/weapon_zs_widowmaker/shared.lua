if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if CLIENT then
	SWEP.PrintName = "Widow Maker G3-SG1"
	SWEP.Slot = 3
	SWEP.SlotPos = 6
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.PrimarySound = Sound("Weapon_G3SG1.Single")
SWEP.PrimaryRecoil = 5.0
SWEP.PrimaryDamage = 38
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.75

SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"

SWEP.Cone = 0.06
SWEP.ConeMoving = 0.1
SWEP.ConeCrouching = 0.04
SWEP.ConeIron = 0.04
SWEP.ConeIronCrouching = 0.01

SWEP.WalkSpeed = 150
