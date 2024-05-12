if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Battleaxe' Handgun"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
end

SWEP.Base = "weapon_zs_base"

SWEP.WalkSpeed = 200

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_pist_usp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.PrimarySound = Sound("Weapon_USP.Single")
SWEP.PrimaryRecoil = 2.5
SWEP.PrimaryDamage = 12
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.2

SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.IronSightsPos = Vector(4.49, -2, 2.65)

SWEP.Cone = 0.075
SWEP.ConeMoving = 0.1
SWEP.ConeCrouching = 0.051
SWEP.ConeIron = 0.05
SWEP.ConeIronCrouching = 0.025
