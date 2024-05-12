if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Ricochete' Magnum"
	SWEP.Author = "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 7
	SWEP.ViewModelFlip = false
end

SWEP.Base = "weapon_zs_base"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_357.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.PrimarySound = Sound("Weapon_357.Single")
SWEP.PrimaryRecoil = 6.75
SWEP.PrimaryDelay = 0.7
SWEP.PrimaryDamage = 52
SWEP.PrimaryNumShots = 1
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"

SWEP.Cone = 0.08
SWEP.ConeMoving = 0.1
SWEP.ConeCrouching = 0.055
SWEP.ConeIron = 0.07
SWEP.ConeIronCrouching = 0.043

SWEP.IronSightsPos = Vector(-5.68, -4, 2.2)
SWEP.IronSightsAng = Vector(1, -0.2, 1)

SWEP.WalkSpeed = 175

local function RicochetCallback(bouncenum, attacker, tr, dmginfo)
	if CLIENT or not tr.HitWorld or tr.HitSky or bouncenum > 1 then return end

	local DotProduct = tr.HitNormal:Dot(tr.Normal * -1)
	local dm = dmginfo:GetDamage() * 0.5
	local bullet = 
	{
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= 2 * tr.HitNormal * DotProduct + tr.Normal,
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "rico_trace",
		Force		= dm,
		Damage		= dm
	}

	timer.Simple( 0.02 * bouncenum, attacker.FireBullets, attacker, bullet)
end

function SWEP:ZSShootBullet(dmg, numbul, cone)
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self.Owner:GetShootPos()
	bullet.Dir = self.Owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Tracer = 1
	bullet.Force = dmg * 0.5
	bullet.Damage = dmg
	bullet.Callback = function(a, b, c) RicochetCallback(0, a, b, c) end

	self.Owner:FireBullets(bullet)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end
