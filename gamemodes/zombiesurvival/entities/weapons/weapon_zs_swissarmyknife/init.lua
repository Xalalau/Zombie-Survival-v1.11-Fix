AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Think()
end

function SWEP:Initialize()
	self:SetWeaponHoldType("melee")
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	self.NextSwing = CurTime() + self.Primary.Delay
	local trace = self.Owner:TraceLine(62)
	local ent = nil
	if trace.HitNonWorld then
		ent = trace.Entity
	end
	if ent and ent:IsValid() then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			self.Owner:EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
			// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
		else
			self.Owner:EmitSound("weapons/knife/knife_hitwall1.wav")
			// util.Decal("ManhackCut", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
		end
		if ent:IsPlayer() then
		    if ent:Team() ~= TEAM_HUMAN then
				ent:TakeDamage(15, self.Owner)
			end
		else
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= self.Owner:GetShootPos()
			bullet.Dir 		= self.Owner:GetAimVector()
			bullet.Spread 	= Vector(0, 0, 0)
			bullet.Tracer	= 0
			bullet.Force	= 1
			bullet.Damage	= 15
			bullet.AmmoType = "Pistol"

			self.Owner:FireBullets(bullet)
			--[[util.BlastDamage(self.Owner, self.Owner, ent:GetPos(), 4, 15)
			if ent:IsValid() and ent:IsOnFire() then
				ent:Extinguish()
			end
			]]
		end
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
 	elseif trace.HitWorld then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			self.Owner:EmitSound("weapons/knife/knife_hit"..math.random(1,4)..".wav")
			// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
		else
			self.Owner:EmitSound("weapons/knife/knife_hitwall1.wav")
			// util.Decal("ManhackCut", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
		end
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	self.Owner:EmitSound("weapons/knife/knife_slash"..math.random(1,2)..".wav")
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
end
