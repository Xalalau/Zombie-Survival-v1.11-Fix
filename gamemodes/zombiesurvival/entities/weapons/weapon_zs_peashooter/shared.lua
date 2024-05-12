if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Peashooter' Handgun"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
end

SWEP.Base = "weapon_zs_base"

SWEP.WalkSpeed = 200

SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Weight = 5

SWEP.PrimarySound = Sound("Weapon_P228.Single")
SWEP.PrimaryRecoil = 2.25
SWEP.PrimaryDamage = 8
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.1

SWEP.Primary.ClipSize = 18
SWEP.Primary.DefaultClip = 54
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Cone = 0.06
SWEP.ConeMoving = 0.11
SWEP.ConeCrouching = 0.022
SWEP.ConeIron = 0.02
SWEP.ConeIronCrouching = 0.015

SWEP.IronSightsPos = Vector(4.76, 0, 2.7)
