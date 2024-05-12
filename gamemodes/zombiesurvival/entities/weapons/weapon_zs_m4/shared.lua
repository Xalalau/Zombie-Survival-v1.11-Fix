if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "smg"
end

if CLIENT then
	SWEP.PrintName = "'Stalker' M4"
	SWEP.Slot = 2
	SWEP.SlotPos = 3
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_rif_m4a1.mdl"
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"

SWEP.PrimarySound = Sound("Weapon_m4a1.Single")
SWEP.PrimaryRecoil = 0.6
SWEP.PrimaryDamage = 15
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.11

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"

SWEP.Cone = 0.1
SWEP.ConeMoving = 0.135
SWEP.ConeCrouching = 0.085
SWEP.ConeIron = 0.08
SWEP.ConeIronCrouching = 0.045

SWEP.WalkSpeed = 170

SWEP.IronSightsPos = Vector(6.23, 0, -1.7)
SWEP.IronSightsAng = Vector(10,1.5,4)
