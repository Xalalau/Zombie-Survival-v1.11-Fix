if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Battleaxe' Handgun"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	killicon.AddFont("weapon_zs_battleaxe", "CSKillIcons", "c", Color(255, 80, 0, 255))
end

SWEP.Base = "weapon_zs_base"

SWEP.WalkSpeed = 200

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

-- Support replacement weapons, so we don't require CSS - Xala
if file.Exists("models/weapons/2_pist_usp.mdl", "GAME") then
	SWEP.ViewModel = "models/weapons/2_pist_usp.mdl"
	SWEP.WorldModel = "models/weapons/3_pist_usp.mdl"
else
	SWEP.ViewModel = "models/weapons/v_pist_usp.mdl"
	SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"
end

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

//SWEP.Primary.Sound = Sound("Weapon_USP.Single")
SWEP.Primary.Sound = Sound("weapons/usp/usp_unsil-1.wav")
SWEP.Primary.Recoil = 2.5
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 12
SWEP.Primary.Delay = 0.2
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0.06
SWEP.ConeMoving = 0.12
SWEP.ConeCrouching = 0.025
