AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.SwapAnims = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(false)
end

function SWEP:Think()
	if self.Leaping then
		if self.Owner:OnGround() then
			self.Leaping = false
			self.NextLeap = CurTime() + 1.5
		else
			local vStart = self.OwnerOffset + self.Owner:GetPos()
			local tr = {}
			tr.start = vStart
			tr.endpos = vStart + self.OwnerAngles
			tr.filter = self.Owner
			local trace = util.TraceLine(tr)
			local ent = nil
			if trace.HitNonWorld then
				ent = trace.Entity
			end
			if ent and ent:IsValid() then
		    	// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
				local phys = ent:GetPhysicsObject()
				if ent:IsPlayer() then
					local vel = self.Owner:EyeAngles():Forward() * 650
					vel.z = 150
					ent:SetVelocity(vel)
					ent:ViewPunch(Angle(math.random(0, 80), math.random(0, 80), math.random(0, 80)))
				elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
					local vel = self.Owner:EyeAngles():Forward() * 35000
					if vel.z < 1800 then vel.z = 1800 end
					phys:ApplyForceCenter(vel)
					ent:SetPhysicsAttacker(self.Owner)
				end
				self.Leaping = false
		    	self.NextLeap = CurTime() + 1.5
				self.Owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				self.Owner:ViewPunch(Angle(math.random(0, 70), math.random(0, 70), math.random(0, 70)))
			elseif trace.HitWorld then
				self.Owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
		    	// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
		    	self.Leaping = false
		    	self.NextLeap = CurTime() + 1.5
			end
		end
	end

	if not self.Swinging then return end
	if CurTime() < self.NextSwing then return end
	if not self.Owner:KeyDown(IN_ATTACK) then
		self.Swinging = false
		GAMEMODE:SetPlayerSpeed(self.Owner, ZombieClasses[self.Owner:GetZombieClass()].Speed)
		return
	end
	local trace = self.Owner:TraceLine(85)
	local ent = nil
	if trace.HitNonWorld then
		ent = trace.Entity
	end
	if ent and ent:IsValid() then
		// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
		local phys = ent:GetPhysicsObject()
		if ent:IsPlayer() then
		    if ent:Team() ~= TEAM_UNDEAD then
				ent:TakeDamage(6, self.Owner)
				if math.random(1, 3) == 1 then
					local effectdata = EffectData()
						effectdata:SetOrigin(trace.HitPos)
						effectdata:SetNormal(trace.HitNormal * -1 + VectorRand() * 0.25)
						effectdata:SetMagnitude(math.random(200, 400))
					util.Effect("bloodstream", effectdata)
				end
			end
		elseif ent:GetClass() == "func_breakable" then
			ent:Fire("addhealth", "-6", 0)
		elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
			local vel = self.Owner:EyeAngles():Forward() * 8000
			if vel.z < 1300 then vel.z = 1300 end
			phys:ApplyForceCenter(vel)
			ent:SetPhysicsAttacker(self.Owner)
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= self.Owner:GetShootPos()
			bullet.Dir 		= (ent:GetPos() - self.Owner:GetShootPos()):Normalize()
			bullet.Spread 	= Vector(0, 0, 0)
			bullet.Tracer	= 0
			bullet.Force	= 1
			bullet.Damage	= 6
			bullet.AmmoType = "Pistol"

			self.Owner:FireBullets(bullet)
		else
			local bullet = {}
			bullet.Num 		= 1
			bullet.Src 		= self.Owner:GetShootPos()
			bullet.Dir 		= (ent:GetPos() - self.Owner:GetShootPos()):Normalize()
			bullet.Spread 	= Vector(0, 0, 0)
			bullet.Tracer	= 0
			bullet.Force	= 1
			bullet.Damage	= 6
			bullet.AmmoType = "Pistol"

			self.Owner:FireBullets(bullet)
			--[[
			util.BlastDamage(self.Owner, self.Owner, ent:GetPos(), 4, 5)
			if ent:IsValid() and ent:IsOnFire() then
				ent:Extinguish()
			end
			]]
		end
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 99, math.random(105, 145))
 	elseif trace.HitWorld then
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 99, math.random(105, 145))
		// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
	else
		self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 99, math.random(105, 145))
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	if self.SwapAnims then self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER) else self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	self.NextSwing = CurTime() + self.Primary.Delay
	self.Owner:Fire("IgnoreFallDamage", "", 0)
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if self.Swinging or self.Leaping then return end
	GAMEMODE:SetPlayerSpeed(self.Owner, ZombieClasses[self.Owner:GetZombieClass()].Speed * 0.5)
	self.NextSwing = CurTime()
	self.Swinging = true
end

SWEP.NextLeap = 0
SWEP.NextClimb = 0
function SWEP:SecondaryAttack()
	if self.Leaping or self.Swinging then return end
	local onground = self.Owner:OnGround()
	if CurTime() >= self.NextClimb and not onground then
		local vStart = self.Owner:GetShootPos()
		local aimvec = self.Owner:GetAimVector() aimvec.z = 0
		local tr = {}
		tr.start = vStart
		tr.endpos = vStart + (aimvec * 35)
		tr.filter = self.Owner
		local Hit = util.TraceLine(tr).Hit
		tr.start = tr.endpos
		tr.endpos = tr.endpos + Vector(0,0,-52)
		local Hit2 = util.TraceLine(tr).Hit
		if Hit or Hit2 then
			self.Owner:SetLocalVelocity(Vector(0,0,150))
			self.Owner:SetAnimation(PLAYER_SUPERJUMP)
			self.NextClimb = CurTime() + self.Secondary.Delay
			self.Owner:EmitSound("player/footsteps/metalgrate"..math.random(1,4)..".wav")
			self.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			return
		end
	end
	if CurTime() < self.NextLeap then return end
	if not onground then return end
	local vel = self.Owner:GetAngles():Forward() * 800
	if vel.z < 200 then vel.z = 200 end
	local eyeangles = self.Owner:GetAngles():Forward()
	eyeangles.pitch = -0.15
	eyeangles.z = -0.1
	local ang = self.Owner:GetAimVector() ang.z = 0
	self.OwnerAngles = ang * 85
	self.OwnerOffset = Vector(0,0,8)
	self.Owner:SetLocalVelocity(vel)
	self.Leaping = true
	self.Owner:EmitSound("npc/fast_zombie/fz_scream1.wav")
	self.Owner:Fire("IgnoreFallDamage", "", 0)
end

function SWEP:Reload()
	return false
end
