if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "shotgun"
end

if CLIENT then
	SWEP.PrintName = "'Shredder' SMG"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 5
	SWEP.IconLetter = "x"
	killicon.AddFont("weapon_zs_smg", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"

-- Support replacement weapons, so we don't require CSS - Xala
if file.Exists("models/weapons/2_smg_mp5.mdl", "GAME") then
	SWEP.ViewModel = "models/weapons/2_smg_mp5.mdl"
	SWEP.WorldModel = "models/weapons/3_smg_mp5.mdl"
else
	SWEP.ViewModel = "models/weapons/v_smg_mp5.mdl"
	SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"
end

SWEP.Weight = 5

//SWEP.Primary.Sound = Sound("Weapon_MP5Navy.Single")
SWEP.Primary.Sound = Sound("weapons/mp5navy/mp5-1.wav")
SWEP.Primary.Recoil = 2.2
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 30
SWEP.Primary.Delay = 0.09
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Cone = 0.09
SWEP.ConeMoving = 0.11
SWEP.ConeCrouching = 0.06

SWEP.WalkSpeed = 170
