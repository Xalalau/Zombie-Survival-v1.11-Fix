if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Owens' Handgun"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ViewModelFlip = false
	SWEP.ViewModelFOV = 60
end

SWEP.Base = "weapon_zs_base"

SWEP.WalkSpeed = 200

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

SWEP.Weight = 5

SWEP.ReloadSound = Sound("Weapon_Pistol.Reload")
SWEP.PrimarySound = Sound("Weapon_Pistol.NPC_Single")
SWEP.PrimaryRecoil = 3.25
SWEP.PrimaryDamage = 7
SWEP.PrimaryNumShots = 2
SWEP.PrimaryDelay = 0.2

SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 36
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Cone = 0.06
SWEP.ConeMoving = 0.08
SWEP.ConeCrouching = 0.05
SWEP.ConeIron = 0.045
SWEP.ConeIronCrouching = 0.04

SWEP.IronSightsPos = Vector(-5.85, -3,4, 0)
SWEP.IronSightsAng = Vector(0.15, -1, 1.5)
