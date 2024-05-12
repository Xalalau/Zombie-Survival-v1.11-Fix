if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "shotgun"
end

if CLIENT then
	SWEP.PrintName = "'Shredder' SMG"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 2
	SWEP.SlotPos = 5
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.Weight = 5

SWEP.PrimarySound = Sound("Weapon_MP5Navy.Single")
SWEP.PrimaryRecoil = 2.2
SWEP.PrimaryDamage = 12
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.09

SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 90
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"

SWEP.Cone = 0.09
SWEP.ConeMoving = 0.11
SWEP.ConeCrouching = 0.06
SWEP.ConeIron = 0.06
SWEP.ConeIronCrouching = 0.05

SWEP.WalkSpeed = 170

SWEP.IronSightsAng = Vector(0.8, 0, 0)
SWEP.IronSightsPos = Vector(4.75, -4, 1.98)
