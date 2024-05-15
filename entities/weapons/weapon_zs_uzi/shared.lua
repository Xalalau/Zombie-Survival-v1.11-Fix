if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Sprayer' Uzi 9mm"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.IconLetter = "l"
	killicon.AddFont("weapon_zs_uzi", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"

SWEP.ViewModel = "models/weapons/v_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mac10.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

//SWEP.Primary.Sound = Sound("Weapon_MAC10.Single")
SWEP.Primary.Sound = Sound("weapons/mac10/mac10-1.wav")
SWEP.Primary.Recoil = 2.5
SWEP.Primary.Damage = 9.5
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 40
SWEP.Primary.Delay = 0.075
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Cone = 0.09
SWEP.ConeMoving = 0.13
SWEP.ConeCrouching = 0.06

SWEP.WalkSpeed = 170
