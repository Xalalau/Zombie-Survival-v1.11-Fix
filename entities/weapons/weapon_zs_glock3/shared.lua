if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Crossfire' Glock 3"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.IconLetter = "c"
	killicon.AddFont("weapon_zs_glock3", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

-- Support replacement weapons, so we don't require CSS - Xala
if file.Exists("models/weapons/2_pist_glock18.mdl", "GAME") then
	SWEP.ViewModel = "models/weapons/2_pist_glock18.mdl"
	SWEP.WorldModel = "models/weapons/3_pist_glock18.mdl"
else
	SWEP.ViewModel = "models/weapons/v_pist_glock18.mdl"
	SWEP.WorldModel = "models/weapons/w_pist_glock18.mdl"
end

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

//SWEP.Primary.Sound = Sound("Weapon_Glock.Single")
SWEP.Primary.Sound = Sound("weapons/glock/glock18-1.wav")
SWEP.Primary.Recoil = 2.5
SWEP.Primary.Damage = 11
SWEP.Primary.NumShots = 3
SWEP.Primary.ClipSize = 7
SWEP.Primary.Delay = 0.3
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0.13
SWEP.ConeMoving = 0.18
SWEP.ConeCrouching = 0.1

SWEP.WalkSpeed = 200
