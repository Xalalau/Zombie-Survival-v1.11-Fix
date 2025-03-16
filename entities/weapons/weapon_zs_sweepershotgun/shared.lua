if SERVER then
	AddCSLuaFile("shared.lua")
end

if CLIENT then
	SWEP.PrintName = "Sweeper SG"
	SWEP.Author	= "JetBoom"
	SWEP.Slot = 3
	SWEP.SlotPos = 1
	SWEP.IconLetter = "0"
	killicon.AddFont("weapon_zs_sweepershotgun", "HL2MPTypeDeath", SWEP.IconLetter, Color(255, 80, 0, 255 ))
end

SWEP.Base = "weapon_zs_base"
SWEP.HoldType = "shotgun"

-- Support replacement weapons, so we don't require CSS - Xala
if file.Exists("models/weapons/2_shot_m3super90.mdl", "GAME") then
	SWEP.ViewModel = "models/weapons/2_shot_m3super90.mdl"
	SWEP.WorldModel = "models/weapons/3_shot_m3super90.mdl"
else
	SWEP.ViewModel = "models/weapons/v_shot_m3super90.mdl"
	SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
end

SWEP.Weight = 10
SWEP.ReloadDelay = 1.1

//SWEP.Primary.Sound = Sound("Weapon_M3.Single")
SWEP.Primary.Sound = Sound("weapons/m3/m3-1.wav")
SWEP.Primary.Recoil = 3.5
SWEP.Primary.Damage = 12
SWEP.Primary.NumShots = 10
SWEP.Primary.ClipSize = 3
SWEP.Primary.Delay = 0.9
SWEP.Primary.DefaultClip = 18
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Cone = 0.21
SWEP.ConeMoving = 0.22
SWEP.ConeCrouching = 0.2

SWEP.WalkSpeed = 120

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
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

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end

	self:EmitSound(self.Primary.Sound)
	if self:GetOwner():GetVelocity():Length() > 25 then
		self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self.ConeMoving)
	else
		if self:GetOwner():Crouching() then
			self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self.ConeCrouching)
		else
			self:ZSShootBullet(self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone)
		end
	end
	self:TakePrimaryAmmo(1)
	self:GetOwner():ViewPunch(Angle(math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0))

	if CLIENT then
		self:SetNetworkedFloat("LastShootTime", CurTime())
	end
end
