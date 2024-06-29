if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Zombie Drill' Desert Eagle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	killicon.AddFont("weapon_zs_deagle", "CSKillIcons", "f", Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

-- Support replacement weapons, so we don't require CSS - Xala
if file.Exists("models/weapons/2_pist_deagle.mdl", "GAME") then
	SWEP.ViewModel = "models/weapons/2_pist_deagle.mdl"
	SWEP.WorldModel = "models/weapons/3_pist_deagle.mdl"
else
	SWEP.ViewModel = "models/weapons/v_pist_deagle.mdl"
	SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"
end

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

//SWEP.Primary.Sound = Sound("Weapon_Deagle.Single")
SWEP.Primary.Sound = Sound("weapons/DEagle/deagle-1.wav")
SWEP.Primary.Recoil = 3.25
SWEP.Primary.Damage = 30
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 7
SWEP.Primary.Delay = 0.3
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0.08
SWEP.ConeMoving = 0.12
SWEP.ConeCrouching = 0.04

SWEP.WalkSpeed = 170
