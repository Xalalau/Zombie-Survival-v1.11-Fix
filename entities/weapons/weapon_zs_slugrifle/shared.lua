if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "'Tiny' Slug Rifle"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 2
	SWEP.IconLetter = "n"
	killicon.AddFont("weapon_zs_slugrifle", "CSKillIcons", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"
SWEP.HoldType = "rpg"

-- Support replacement weapons, so we don't require CSS - Xala
if file.Exists("models/weapons/2_shot_xm1014.mdl", "GAME") then
	SWEP.ViewModel = "models/weapons/2_shot_xm1014.mdl"
	SWEP.WorldModel = "models/weapons/3_shot_xm1014.mdl"
else
	SWEP.ViewModel = "models/weapons/v_shot_xm1014.mdl"
	SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"
end

SWEP.Weight = 6
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

//SWEP.Primary.Sound = Sound("Weapon_AWP.Single")
SWEP.Primary.Sound = Sound("weapons/awp/awp1.wav")
SWEP.Primary.Recoil = 5.0
SWEP.Primary.Damage = 92
SWEP.Primary.NumShots = 1
SWEP.Primary.ClipSize = 2
SWEP.Primary.Delay = 1.5
SWEP.Primary.DefaultClip = 10
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.ReloadDelay = 1.5
SWEP.Primary.Cone = 0.04
SWEP.ConeMoving = 0.16
SWEP.ConeCrouching = 0

SWEP.WalkSpeed = 150

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

SWEP.NextReload = 0
function SWEP:Reload()
	if CurTime() < self.NextReload then return end
	self.NextReload = CurTime() + self.Primary.Delay * 2
	
	if self:Clip1() < self.Primary.ClipSize and self:GetOwner():GetAmmoCount(self.Primary.Ammo) > 0 then
		self:SetNetworkedBool( "reloading", true )
		self:DefaultReload( ACT_VM_RELOAD )
		timer.Simple(0.25, function()
			if IsValid(self) then
				self:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
			end
		end)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	end
end
