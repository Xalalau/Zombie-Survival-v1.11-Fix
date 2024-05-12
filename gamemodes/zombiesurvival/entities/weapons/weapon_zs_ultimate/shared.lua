if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "Ultimate"
	SWEP.Slot = 1
	SWEP.SlotPos = 8
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.PrimarySound = Sound("Weapon_m249.Single")
SWEP.PrimaryRecoil = 1.5
SWEP.PrimaryDamage = 20
SWEP.PrimaryNumShots = 12
SWEP.PrimaryDelay = 0.4

SWEP.Primary.ClipSize = 4
SWEP.Primary.DefaultClip = 12
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Cone = 0.25
SWEP.ConeMoving = 0.30
SWEP.ConeCrouching = 0.23
