AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.ZombieOnly = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.NextSwing = 0
SWEP.NextLeap = 0
SWEP.NextClimb = 0
SWEP.SwingStop = 0

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(false)
end

function SWEP:Think()
	local owner = self.Owner
	if self.Swinging and not owner:KeyDown(IN_ATTACK) and self.SwingStop < CurTime() then
		self.Swinging = false
		self.SwingStop = 0
		GAMEMODE:SetPlayerSpeed(owner, owner.ClassTable.Speed)
	end

	if self.Leaping then
		if owner:OnGround() or owner:WaterLevel() > 0 then
			self.Leaping = false
			self.NextLeap = CurTime() + 1
		else
			local vStart = self.OwnerOffset + owner:GetPos()
			local tr = {}
			tr.start = vStart
			tr.endpos = vStart + self.OwnerAngles
			tr.filter = owner
			local trace = util.TraceLine(tr)
			local ent = trace.Entity

			for _, fin in pairs(ents.FindInSphere(vStart + owner:GetAimVector() * 16, 16)) do
				if fin:IsPlayer() and fin:Team() ~= owner:Team() and fin:Alive() and TrueVisible(vStart, fin:NearestPoint(vStart)) then
					ent = fin
					break
				end
			end

			if ent:IsValid() then
				if ent:GetClass() == "func_breakable_surf" then
					ent:Fire("break", "", 0)
				else
					local phys = ent:GetPhysicsObject()
					if ent:IsPlayer() then
						local vel = owner:EyeAngles():Forward() * 650
						vel.z = 150
						ent:SetVelocity(vel)
						ent:ViewPunch(Angle(math.random(0, 80), math.random(0, 80), math.random(0, 80)))
						ent:TakeDamage(5 --[[+ 2.5 * math.min(GetZombieFocus(owner:GetPos(), FOCUS_RANGE, 0.0005, 0) - 0.15, 1)]] , owner)
					elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
						local vel = owner:GetAimVector() * 1000

						phys:ApplyForceOffset(vel, (owner:TraceLine(65).HitPos + ent:GetPos()) * 0.5)
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
			else
				self:NextThink(CurTime())
				return true
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if self.Leaping or CurTime() < self.NextSwing then return end

	self.NextSwing = CurTime() + self.PrimaryDelay
	self.SwingStop = CurTime() + 0.5

	local owner = self.Owner

	if not self.Swinging then
		GAMEMODE:SetPlayerSpeed(owner, 1)
		self.Swinging = true
	end

	local trace = owner:TraceLine(85, MASK_SHOT)
	local ent = trace.Entity

	if trace.HitWorld then
		owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 80, math.random(105, 145))
		--util.Decal("Blood", trace.HitPos + trace.HitNormal*10, trace.HitPos - trace.HitNormal*10)
	else
		owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 80, math.random(105, 145))
	end

	owner:RestartGesture(ACT_MELEE_ATTACK1)
	if self.SwapAnims then self:SendWeaponAnim(ACT_VM_HITCENTER) else self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	owner:Fire("IgnoreFallDamage", "", 0)

	if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local damage = 7 -- + 3.25 * math.min(GetZombieFocus(owner:GetPos(), FOCUS_RANGE, 0.001, 0) - 0.3, 1)
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
end

function SWEP:SecondaryAttack()
	if self.Leaping or self.Swinging then return end
	local owner = self.Owner
	local onground = owner:OnGround()
	if onground then
		if self.NextLeap < CurTime() then
			local vel = owner:GetAngles():Forward() * 800
			if vel.z < 200 then vel.z = 200 end
			local eyeangles = owner:GetAngles():Forward()
			eyeangles.pitch = -0.15
			eyeangles.z = -0.1
			local ang = owner:GetAimVector() ang.z = 0
			self.OwnerAngles = ang * 85
			self.OwnerOffset = Vector(0,0,16)
			owner:SetGroundEntity(NULL)
			owner:SetLocalVelocity(vel)
			owner:SetAnimation(PLAYER_JUMP)
			self.Leaping = true
			owner:EmitSound("npc/fast_zombie/fz_scream1.wav")
			owner:Fire("IgnoreFallDamage", "", 0)
		end
	elseif self.NextClimb < CurTime() then
		local vStart = owner:GetShootPos()
		local aimvec = owner:GetAimVector() aimvec.z = 0
		local tr = {start = vStart, endpos = vStart + aimvec * 35, filter = owner}
		local Hit = util.TraceLine(tr).Hit
		tr.start = tr.endpos
		tr.endpos = tr.endpos + Vector(0,0,-52)
		local Hit2 = util.TraceLine(tr).Hit
		if Hit or Hit2 then
			owner:SetLocalVelocity(Vector(0,0,150))
			owner:RestartGesture(ACT_CLIMB_UP)
			self.NextClimb = CurTime() + self.SecondaryDelay
			owner:EmitSound("player/footsteps/metalgrate"..math.random(1,4)..".wav")
			if self.SwapAnims then self:SendWeaponAnim(ACT_VM_HITCENTER) else self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
			self.SwapAnims = not self.SwapAnims
			return
		end
	end
end

function SWEP:Reload()
	return false
end
