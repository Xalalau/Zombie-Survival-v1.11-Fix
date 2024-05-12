if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "shotgun"
end

if CLIENT then
	SWEP.PrintName = "'Bullet Storm' SMG"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 2
	SWEP.SlotPos = 1
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"

SWEP.Weight = 5

SWEP.PrimarySound = Sound("Weapon_p90.Single")
SWEP.PrimaryRecoil = 2.2
SWEP.PrimaryDamage = 8
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.08

SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"

SWEP.Cone = 0.1
SWEP.ConeMoving = 0.11
SWEP.ConeCrouching = 0.08
SWEP.ConeIron = 0.08
SWEP.ConeIronCrouching = 0.06

SWEP.WalkSpeed = 170

SWEP.IronSightsPos = Vector(4.5, -4, 2)
