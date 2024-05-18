if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.HoldType = "pistol"
end

if CLIENT then
	SWEP.PrintName = "'Ricochete' Magnum"
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.ViewModelFlip = false

	killicon.AddFont("weapon_zs_magnum", "HL2MPTypeDeath", ".", Color(255, 80, 0, 255))
end

SWEP.Base				= "weapon_zs_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/w_357.mdl"

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.Primary.Sound			= Sound("Weapon_357.Single")
SWEP.Primary.Recoil			= 6.75
SWEP.Primary.Damage			= 45
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= 6
SWEP.Primary.Delay			= 0.75
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize * 3
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Cone			= 0.115
SWEP.ConeMoving				= 0.15
SWEP.ConeCrouching			= 0.06

SWEP.WalkSpeed = 170

local function RicochetCallback(bouncenum, attacker, tr, dmginfo)
	if not tr.HitWorld or tr.HitSky then return end

	if CLIENT then return end
	if bouncenum > 1 then return end

	local DotProduct = tr.HitNormal:Dot(tr.Normal * -1)
	local dm = dmginfo:GetDamage() * 0.5
	local bullet = 
	{
		Num 		= 1,
		Src 		= tr.HitPos,
		Dir 		= ( 2 * tr.HitNormal * DotProduct ) + tr.Normal,
		Spread 		= Vector( 0, 0, 0 ),
		Tracer		= 1,
		TracerName 	= "rico_trace",
		Force		= dm,
		Damage		= dm
	}

	timer.Simple( 0.02 * bouncenum, function()
		if IsValid(attacker) then
			attacker:FireBullets(bullet)
		end
	end)
end

function SWEP:ZSShootBullet(dmg, numbul, cone)
	local bullet = {}
	bullet.Num = numbul
	bullet.Src = self:GetOwner():GetShootPos()
	bullet.Dir = self:GetOwner():GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Tracer = 1
	bullet.Force = dmg * 0.5
	bullet.Damage = dmg
	bullet.Callback = function(a, b, c) RicochetCallback(0, a, b, c) end

	self:GetOwner():FireBullets(bullet)

	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():MuzzleFlash()
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
end
