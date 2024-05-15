if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Peashooter' Handgun"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 8
	killicon.AddFont("weapon_zs_peashooter", "CSKillIcons", "a", Color(255, 80, 0, 255))
end

SWEP.Base = "weapon_zs_base"

SWEP.WalkSpeed = 200

SWEP.ViewModel = "models/weapons/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/w_pist_p228.mdl"

SWEP.Weight = 5

//SWEP.Primary.Sound = Sound("Weapon_P228.Single")
SWEP.Primary.Sound = Sound("weapons/p228/p228-1.wav")
SWEP.Primary.Recoil = 2.25
SWEP.Primary.Damage = 8
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 18
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0.06
SWEP.ConeMoving = 0.11
SWEP.ConeCrouching = 0.022
