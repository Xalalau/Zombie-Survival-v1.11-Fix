AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.SwapAnims = false

function SWEP:Deploy()
	self:GetOwner():DrawViewModel(true)
	self:GetOwner():DrawWorldModel(false)
end

function SWEP:Think()
	local owner = self:GetOwner()
	if self.Leaping then
		if owner:OnGround() or owner:WaterLevel() > 0 then
			self.Leaping = false
			self.NextLeap = CurTime() + 1
		else
			local vStart = self:GetOwner():GetViewOffset() + owner:GetPos()
			local tr = {}
			tr.start = vStart
			tr.endpos = vStart + self:GetOwner():GetAngles()
			tr.filter = owner
			local trace = util.TraceLine(tr)
			local ent = trace.Entity

			if ent and ent:IsValid() then
				if ent:GetClass() == "func_breakable_surf" then
					ent:Fire("break", "", 0)
				else
					local phys = ent:GetPhysicsObject()
					if ent:IsPlayer() then
						local vel = owner:EyeAngles():Forward() * 650
						vel.z = 150
						ent:SetVelocity(vel)
						ent:ViewPunch(Angle(math.random(0, 80), math.random(0, 80), math.random(0, 80)))
						ent:TakeDamage(5 + 5 * math.min(GetZombieFocus(owner:GetPos(), 300, 0.0005, 0) - 0.15, 1), owner)
					elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
						local vel = owner:GetAimVector() * 1000

						phys:ApplyForceOffset(vel, (owner:TraceLine(65).HitPos + ent:GetPos()) / 2)
						ent:SetPhysicsAttacker(owner)
					end
				end
				self.Leaping = false
				self.NextLeap = CurTime() + 1.5
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				owner:ViewPunch(Angle(math.random(0, 70), math.random(0, 70), math.random(0, 70)))
			elseif trace.HitWorld then
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				self.Leaping = false
				self.NextLeap = CurTime() + 1.5
			end
		end
	end

	if not self.Swinging then return end
	if CurTime() < self.NextSwing then return end
	if not owner:KeyDown(IN_ATTACK) then
		self.Swinging = false
		//GAMEMODE:SetPlayerSpeed(owner, ZombieClasses[owner:GetZombieClass()].Speed)
		return
	end
	local trace = owner:TraceLine(85, MASK_SHOT)
	local ent = trace.Entity

	local damage = 5 + 5 * math.min(GetZombieFocus(owner:GetPos(), 300, 0.001, 0) - 0.3, 1)

	if ent and ent:IsValid() then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
				local vel = damage * 600 * owner:EyeAngles():Forward()

				phys:ApplyForceOffset(vel, (ent:NearestPoint(owner:GetShootPos()) + ent:GetPos() * 2) / 3)
				ent:SetPhysicsAttacker(owner)
			end
			owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 80, math.random(105, 145))
			ent:TakeDamage(damage, owner)
		end
	end

 	if trace.HitWorld then
		owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 80, math.random(105, 145))
		// util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
	else
		owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 80, math.random(105, 145))
	end

	owner:SetAnimation(PLAYER_ATTACK1)
	if self.SwapAnims then self:SendWeaponAnim(ACT_VM_HITCENTER) else self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	self.NextSwing = CurTime() + self.Primary.Delay
	owner:Fire("IgnoreFallDamage", "", 0)
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if self.Swinging or self.Leaping then return end
	//GAMEMODE:SetPlayerSpeed(self:GetOwner(), ZombieClasses[self:GetOwner():GetZombieClass()].Speed * 0.5)
	self.NextSwing = CurTime()
	self.Swinging = true
end

SWEP.NextLeap = 0
SWEP.NextClimb = 0
function SWEP:SecondaryAttack()
	if self.Leaping or self.Swinging then return end
	local onground = self:GetOwner():OnGround()
	if CurTime() >= self.NextClimb and not onground then
		local vStart = self:GetOwner():GetShootPos()
		local aimvec = self:GetOwner():GetAimVector() aimvec.z = 0
		local tr = {}
		tr.start = vStart
		tr.endpos = vStart + (aimvec * 35)
		tr.filter = self:GetOwner()
		local Hit = util.TraceLine(tr).Hit
		tr.start = tr.endpos
		tr.endpos = tr.endpos + Vector(0,0,-52)
		local Hit2 = util.TraceLine(tr).Hit
		if Hit or Hit2 then
			self:GetOwner():SetLocalVelocity(Vector(0,0,150))
			self:GetOwner():SetAnimation(PLAYER_SUPERJUMP)
			self.NextClimb = CurTime() + self.Secondary.Delay
			self:GetOwner():EmitSound("player/footsteps/metalgrate"..math.random(1,4)..".wav")
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			return
		end
	end
	if CurTime() < self.NextLeap then return end
	if not onground then return end
	local vel = self:GetOwner():GetAngles():Forward() * 800
	if vel.z < 200 then vel.z = 200 end
	local eyeangles = self:GetOwner():GetAngles():Forward()
	eyeangles.pitch = -0.15
	eyeangles.z = -0.1
	local ang = self:GetOwner():GetAimVector() ang.z = 0
	self:GetOwner():SetViewOffset(ang * 85)
	self:GetOwner():SetAngles(Vector(0,0,7))
	self:GetOwner():SetGroundEntity(NULL)
	self:GetOwner():SetLocalVelocity(vel)
	self.Leaping = true
	self:GetOwner():EmitSound("npc/fast_zombie/fz_scream1.wav")
	self:GetOwner():Fire("IgnoreFallDamage", "", 0)
end

function SWEP:Reload()
	return false
end
