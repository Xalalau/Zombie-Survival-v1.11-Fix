if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "rpg"
end

if CLIENT then
	SWEP.PrintName = "Slug Rifle"			
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_slugrifle", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_shot_xm1014.mdl"
SWEP.WorldModel			= "models/weapons/w_shot_xm1014.mdl"

SWEP.Weight				= 6
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("npc/sniper/sniper1.wav")
SWEP.Primary.Recoil			= 5.0
SWEP.Primary.Damage			= 85
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.005
SWEP.Primary.ClipSize		= 2
SWEP.Primary.Delay			= 1.5
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"
SWEP.Primary.ReloadDelay	= 1.5

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

function SWEP:Reload()
	self.Weapon:DefaultReload(ACT_VM_RELOAD)
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.ReloadDelay)
end
