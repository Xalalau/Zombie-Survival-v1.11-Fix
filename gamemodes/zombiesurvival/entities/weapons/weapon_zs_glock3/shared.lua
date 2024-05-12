if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Crossfire' Glock 3"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 6
end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl"
SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.PrimarySound = Sound("Weapon_Glock.Single")
SWEP.PrimaryRecoil = 2.5
SWEP.PrimaryDamage = 11
SWEP.PrimaryNumShots = 3
SWEP.PrimaryDelay = 0.3

SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 21
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Cone = 0.13
SWEP.ConeMoving = 0.18
SWEP.ConeCrouching = 0.1
SWEP.ConeIron = 0.1
SWEP.ConeIronCrouching = 0.09

SWEP.WalkSpeed = 200
SWEP.IronSightsPos = Vector(4.3, -2, 2.75)
