AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.ZombieOnly = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
end

function SWEP:Think()
	local owner = self.Owner
	if self.GoingToSpit and CurTime() > self.GoingToSpit then
		owner:Freeze(false)
		self.GoingToSpit = nil
		self.NextSpit = CurTime() + 3

		owner:EmitSound("weapons/crossbow/bolt_fly4.wav", 80, 150)

		local ent = ents.Create("projectile_spit")
		if ent:IsValid() then
			ent:SetOwner(owner)
			local aimvec = owner:GetAimVector()
			aimvec.z = math.max(aimvec.z, 0.2)
			aimvec = aimvec:Normalize()
			local vStart = owner:GetShootPos() + Vector(0, 0, -48)
			local tr = util.TraceLine({start=vStart, endpos=vStart + owner:GetAimVector() * 30, filter=owner})
			if tr.Hit then
				ent:SetPos(tr.HitPos + tr.HitNormal * 4)
			else
				ent:SetPos(tr.HitPos)
			end
			ent:Spawn()
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:ApplyForceCenter(aimvec * 2500)
			end
		end
	elseif self.GoingToLeap and CurTime() > self.GoingToLeap then
		owner:Freeze(false)
		self.GoingToLeap = nil
		if owner:OnGround() then
			local vel = self.RememberAngles:Forward() * 450
			if vel.z < 250 then vel.z = 250 end
			local eyeangles = owner:GetAngles():Forward()
			eyeangles.pitch = -0.15
			eyeangles.z = 0
			local ang = owner:GetAimVector() ang.z = 0
			self.OwnerAngles = ang * 45
			self.OwnerOffset = Vector(0,0,14)
			owner:SetGroundEntity(NULL)
			owner:SetLocalVelocity(vel)

			self.Leaping = true

			owner:EmitSound("npc/headcrab_poison/ph_jump"..math.random(1,3)..".wav")
		end
	elseif self.Leaping then
		if owner:OnGround() or 0 < owner:WaterLevel() then
			self.Leaping = false
			self.NextLeap = CurTime() + 0.8
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
				local phys = ent:GetPhysicsObject()

				if phys:IsValid() and not ent:IsNPC() and not ent:IsPlayer() and phys:IsMoveable() then
					local vel = 12000 * owner:EyeAngles():Forward()

					phys:ApplyForceOffset(vel, (ent:NearestPoint(vStart) + ent:GetPos() * 2) / 3)
					ent:SetPhysicsAttacker(owner)
				end

				self.Leaping = false
				self.NextLeap = CurTime() + 1
				owner:EmitSound("npc/headcrab_poison/ph_poisonbite"..math.random(1,3)..".wav")
				owner:ViewPunch(Angle(math.random(0, 30), math.random(0, 30), math.random(0, 30)))
				if ent:IsPlayer() and ent:Team() ~= owner:Team() then
					ent:TakeDamage(5, owner)
					local timername = tostring(ent).."poisonedby"..tostring(owner)
					timer.Create(timername, 2, math.random(7, 10), DoPoisoned, ent, owner, timername)
					umsg.Start("PoisonEffect", ent)
					umsg.End()
				else
					ent:TakeDamage(25, owner)
				end
			elseif trace.HitWorld then
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				self.Leaping = false
				self.NextLeap = CurTime() + 1
			else
				self:NextThink(CurTime())
				return true
			end
		end
	end
end

SWEP.NextLeap = 0

function SWEP:PrimaryAttack()
	if self.Leaping or self.GoingToSpit then return end
	local owner = self.Owner

	owner:Fire("IgnoreFallDamage", "", 0)

	if CurTime() < self.NextLeap then return end

	if not owner:OnGround() then return end

	self.GoingToLeap = CurTime() + 1.25
	owner:RestartGesture(ACT_RANGE_ATTACK1)
	owner:EmitSound("npc/headcrab_poison/ph_scream"..math.random(1,3)..".wav")

	self.RememberAngles = owner:GetAngles()

	owner:Freeze(true)
end

SWEP.NextSpit = 0

function SWEP:SecondaryAttack()
	if self.Leaping or self.GoingToSpit or CurTime() < self.NextSpit then return end

	self.GoingToSpit = CurTime() + 1.25
	local owner = self.Owner
	owner:SetAnimation(PLAYER_ATTACK1)
	owner:RestartGesture(owner:LookupSequence("Spitattack"))
	owner:EmitSound("npc/headcrab_poison/ph_scream"..math.random(1,3)..".wav")

	owner:Freeze(true)
end

function SWEP:Reload()
	return false
end
