if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if CLIENT then
	SWEP.PrintName = "'Inferno' AUG"
	SWEP.Slot = 2
	SWEP.SlotPos = 2
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_rif_aug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_aug.mdl"

SWEP.PrimarySound = Sound("Weapon_AUG.Single")
SWEP.PrimaryRecoil = 5.0
SWEP.PrimaryDamage = 14
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.11

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.Cone = 0.05
SWEP.ConeMoving = 0.08
SWEP.ConeCrouching = 0.035
SWEP.ConeIron = 0.035
SWEP.ConeIronCrouching = 0.03

SWEP.WalkSpeed = 170

SWEP.IronSightsAng = Vector(1, 1, 0)
SWEP.IronSightsPos = Vector(4.5, 0, 2.7)
