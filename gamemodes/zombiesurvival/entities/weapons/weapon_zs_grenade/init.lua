AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(true)

	self.NextDeploy = CurTime() + 0.025

	GAMEMODE:WeaponDeployed(self.Owner, self)

	return true
end

function SWEP:Holster()
	self.NextDeploy = nil
	return true
end

function SWEP:Initialize()
	self:SetWeaponHoldType("grenade")
	self:SetDeploySpeed(1.1)
end

function SWEP:Think()
	local ammocount = self.Owner:GetAmmoCount(self.Primary.Ammo)
	if 0 < ammocount then
		self:SetClip1(ammocount + self:Clip1())
		self.Owner:RemoveAmmo(ammocount, self.Primary.Ammo)
	end

	if self.NextDeploy and self.NextDeploy < CurTime() then
		if 0 < self:Clip1() then
			self:SendWeaponAnim(ACT_VM_DRAW)
		else
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		end
	end
end

function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	local owner = self.Owner
	local ent = ents.Create("projectile_zsgrenade")
	if ent:IsValid() then
		ent:SetPos(owner:GetShootPos())
		ent:SetOwner(owner)
		ent:Spawn()
		ent:EmitSound("WeaponFrag.Throw")
		local phys = ent:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:AddAngleVelocity(VectorRand():Angle() * 3)
			phys:SetVelocityInstantaneous(self.Owner:GetAimVector() * 800)
		end
		self:TakePrimaryAmmo(1)
		self.NextDeploy = CurTime() + 1.5
	end

	self:SendWeaponAnim(ACT_VM_THROW)
	owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
end
