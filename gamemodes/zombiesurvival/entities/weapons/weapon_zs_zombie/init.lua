AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

-- This is to get around that dumb thing where the view anims don't play right.
SWEP.SwapAnims = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(false)
end

-- This is kind of unique. It does a trace on the pre swing to see if it hits anything
-- and then if the after-swing doesn't hit anything, it hits whatever it hit in
-- the pre-swing, as long as the distance is low enough.

function SWEP:Think()
	if not self.NextHit then return end
	if CurTime() < self.NextHit then return end
	self.NextHit = nil
	local trace = self.Owner:TraceLine(85)
	local ent = nil
	if trace.HitNonWorld then
		ent = trace.Entity
	elseif self.PreHit and self.PreHit:IsValid() then
	    if self.PreHit:GetPos():Distance(self.Owner:GetShootPos()) < 125 then
	    	ent = self.PreHit
	    end
	end
	if ent and ent:IsValid() then
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
		local phys = ent:GetPhysicsObject()
		if ent:IsPlayer() then
		    if ent:Team() ~= TEAM_UNDEAD then
				ent:TakeDamage(32, self.Owner)
				for i=1, math.random(1, 3) do
					local effectdata = EffectData()
						effectdata:SetOrigin(trace.HitPos)
						effectdata:SetNormal(trace.HitNormal * -1 + VectorRand() * 0.25)
						effectdata:SetMagnitude(math.random(500, 700))
					util.Effect("bloodstream", effectdata)
				end
			else
				local vel = self.Owner:EyeAngles():Forward() * 400
				vel.z = 100
				ent:SetVelocity(vel)
			end
		elseif ent:GetClass() == "func_breakable" then
			ent:Fire("addhealth", "-32", 0) // I had to add this because bullets would go through glass and then hit players on the other side, even if they were a mile away.
		elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
			local vel = self.Owner:EyeAngles():Forward() * 35000
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
			bullet.Damage	= 32
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
			bullet.Damage	= 32
			bullet.AmmoType = "Pistol"

			self.Owner:FireBullets(bullet)
		end
 	elseif trace.HitWorld then
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
	end
	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
	self.PreHit = nil
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	if self.SwapAnims then self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER) else self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextHit = CurTime() + 0.6
	local trace = self.Owner:TraceLine(85)
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	self.Owner:SetAnimation(PLAYER_SUPERJUMP)

	self.Owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav")
	self.NextYell = CurTime() + 2
end

function SWEP:Reload()
	return false
end
