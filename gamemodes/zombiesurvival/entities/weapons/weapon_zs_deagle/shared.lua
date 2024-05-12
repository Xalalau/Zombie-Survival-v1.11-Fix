if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Zombie Drill' Desert Eagle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 4
end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.PrimarySound = Sound("Weapon_Deagle.Single")
SWEP.PrimaryRecoil = 3.25
SWEP.PrimaryDamage = 30
SWEP.PrimaryNumShots = 1
SWEP.PrimaryDelay = 0.3

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 21
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Cone = 0.085
SWEP.ConeMoving = 0.13
SWEP.ConeCrouching = 0.05
SWEP.ConeIron = 0.055
SWEP.ConeIronCrouching = 0.04

SWEP.WalkSpeed = 170

SWEP.IronSightsPos = Vector(5.15, -2, 2.7)
