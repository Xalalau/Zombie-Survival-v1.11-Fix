AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

-- This is to get around that dumb thing where the view anims don't play right.
SWEP.SwapAnims = false
SWEP.Headcrabs = 2

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
end

function SWEP:Think()
	if not self.NextHit then return end
	if CurTime() < self.NextHit then return end
	self.NextHit = nil
	local trace = self.Owner:TraceLine(95)
	local ent = nil
	if trace.HitNonWorld then
		ent = trace.Entity
	elseif self.PreHit and self.PreHit:IsValid() then
	    if self.PreHit:GetPos():Distance(self.Owner:GetShootPos()) < 135 then
	    	ent = self.PreHit
	    end
	end
	if ent and ent:IsValid() then
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 100, 80)
		// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
		local phys = ent:GetPhysicsObject()
		if ent:IsPlayer() then
		    if ent:Team() ~= TEAM_UNDEAD then
				ent:TakeDamage(50, self.Owner)
				for i=1, math.random(2, 4) do
					local effectdata = EffectData()
						effectdata:SetOrigin(trace.HitPos)
						effectdata:SetNormal(trace.HitNormal * -1 + VectorRand() * 0.25)
						effectdata:SetMagnitude(math.random(700, 900))
					util.Effect("bloodstream", effectdata)
				end
			else
				local vel = self.Owner:EyeAngles():Forward() * 500
				vel.z = 120
				ent:SetVelocity(vel)
			end
		elseif ent:GetClass() == "func_breakable" then
			ent:Fire("addhealth", "-50", 0)
		elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
			local vel = self.Owner:EyeAngles():Forward() * 45000
			if vel.z < 1800 then vel.z = 1800 end
			phys:ApplyForceCenter(vel)
			ent:SetPhysicsAttacker(self.Owner)
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= self.Owner:GetShootPos()
			bullet.Dir 		= self.Owner:GetAimVector()
			bullet.Spread 	= Vector(0, 0, 0)
			bullet.Tracer	= 0
			bullet.Force	= 1
			bullet.Damage	= 50
			bullet.AmmoType = "Pistol"

			self.Owner:FireBullets(bullet)
		
		else
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= self.Owner:GetShootPos()
			bullet.Dir 		= self.Owner:GetAimVector()
			bullet.Spread 	= Vector(0, 0, 0)
			bullet.Tracer	= 0
			bullet.Force	= 1
			bullet.Damage	= 50
			bullet.AmmoType = "Pistol"

			self.Owner:FireBullets(bullet)
		end
 	elseif trace.HitWorld then
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 100, 80)
		// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
	end
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 100, 80)
	self.PreHit = nil
	//GAMEMODE:SetPlayerSpeed(self.Owner, ZombieClasses[self.Owner:GetZombieClass()].Speed)
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	if self.SwapAnims then self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER) else self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound("npc/zombie_poison/pz_warn"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextHit = CurTime() + 1
	local trace = self.Owner:TraceLine(95)
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
	//GAMEMODE:SetPlayerSpeed(self.Owner, ZombieClasses[self.Owner:GetZombieClass()].Speed * 0.6)
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	if self.Headcrabs <= 0 then
		self.Owner:EmitSound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav")
		self.NextYell = CurTime() + 2
		return
	end
	self.Owner:SetAnimation(PLAYER_SUPERJUMP)
	self.Owner:EmitSound("npc/zombie_poison/pz_throw"..math.random(2,3)..".wav")
	GAMEMODE:SetPlayerSpeed(self.Owner, 1)
	self.NextYell = CurTime() + 4
	timer.Simple(1, ThrowHeadcrab, self.Owner, self)
end

function SWEP:Reload()
	return false
end
