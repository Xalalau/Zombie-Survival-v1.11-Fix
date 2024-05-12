if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "ar2"
end

if CLIENT then
	SWEP.PrintName = "'Reaper' UMP"
	SWEP.Slot = 2
	SWEP.SlotPos = 4
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/w_smg_ump45.mdl"


SWEP.PrimarySound = Sound("Weapon_UMP45.Single")
SWEP.PrimaryRecoil = 5.0
SWEP.PrimaryDamage = 19
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.13

SWEP.Primary.ClipSize = 28
SWEP.Primary.DefaultClip = 100
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"

SWEP.Cone = 0.07
SWEP.ConeMoving = 0.08
SWEP.ConeCrouching = 0.06
SWEP.ConeIron = 0.065
SWEP.ConeIronCrouching = 0.045

SWEP.WalkSpeed = 200

SWEP.IronSightsPos = Vector(7.3, -5, 3.1)
SWEP.IronSightsAng = Vector(-1, 0.2, 2.55)
