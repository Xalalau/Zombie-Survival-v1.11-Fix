if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Sprayer' Uzi 9mm"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 2
	SWEP.SlotPos = 6
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.PrimarySound = Sound("Weapon_MAC10.Single")
SWEP.PrimaryRecoil = 2.5
SWEP.PrimaryDamage = 9.5
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.075

SWEP.Primary.ClipSize = 40
SWEP.Primary.DefaultClip = 120
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"

SWEP.Cone = 0.09
SWEP.ConeMoving = 0.13
SWEP.ConeCrouching = 0.07
SWEP.ConeIron = 0.065
SWEP.ConeIronCrouching = 0.06

SWEP.WalkSpeed = 170

SWEP.IronSightsPos = Vector(6.25, -4, 0)
SWEP.IronSightsAng = Vector(6, 2, 6)
