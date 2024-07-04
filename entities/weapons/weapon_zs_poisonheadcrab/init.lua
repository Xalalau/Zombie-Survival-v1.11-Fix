AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:SetNextSpit(time)
	self:SetDTFloat(0, time)
end

function SWEP:SetLeaping(leap)
	self:SetDTBool(0, leap)
end

function SWEP:SetNextLeap(time)
	self:SetDTFloat(1, time)
end

function SWEP:Deploy()
	local owner = self:GetOwner()
	owner:DrawViewModel(false)
	owner:DrawWorldModel(false)
	net.Start("RcHCScale")
		net.WriteEntity(owner)
	net.Broadcast()
	self:SetNextSpit(0)
	self:SetNextLeap(0)
end

function SWEP:CalcHit()
	local owner = self:GetOwner()
	local vStart = owner:GetPos()
	local tr = {}
	local vForwad = self:GetForward()

	tr.start = vStart
	tr.endpos = vStart + vForwad * 35 + Vector(0, 0, 10)
	tr.filter = owner
	local trace = util.TraceLine(tr)
	local ent = trace.Entity

	if not ent:IsValid() then
		local updown = owner:GetForward().z
		local aimvectormultilier
		if updown > 0.25 then
			updown = Vector(0, 0, owner:GetForward().z * 47)
			aimvectormultilier = 1
		else
			updown = Vector(0, 0,0)
			aimvectormultilier = 10
		end		

		for _, fin in ipairs(ents.FindInSphere(owner:GetPos() + Vector(0, 0, 1.7) + owner:GetAimVector() * aimvectormultilier + updown, 10)) do
			if fin:IsPlayer() and fin:Team() ~= owner:Team() and fin:Alive() then
				ent = fin
				break
			end
		end
	end

	return trace, ent
end

function SWEP:Think()
	local owner = self:GetOwner()
	if self:IsGoingToSpit() and CurTime() > self:GetNextSpit() then
		owner:Freeze(false)
		self:SetNextSpit(0)
		self:SetNextSecondaryFire(CurTime() + 3)
		local ent = ents.Create("projectile_spit")
		if ent:IsValid() then
			ent:SetOwner(owner)
			ent:Spawn()
		end
	elseif self:IsGoingToLeap() and CurTime() > self:GetNextLeap() then
		owner:Freeze(false)
		self:SetNextLeap(0)
		if owner:OnGround() then
			local vel = self.RememberAngles:Forward() * 450
			if vel.z < 250 then vel.z = 250 end
			local eyeangles = owner:GetAngles():Forward()
			eyeangles.pitch = -0.15
			eyeangles.z = -0.1
			local ang = owner:GetAimVector() ang.z = 0
			self:GetOwner():GetViewOffset(ang * 45)
			self:GetOwner():GetAngles(Vector(0,0,6))
			owner:SetGroundEntity(NULL)
			owner:SetLocalVelocity(vel)

			self:SetLeaping(true)

			owner:EmitSound("npc/headcrab_poison/ph_jump"..math.random(1,3)..".wav")
		end
	elseif self:IsLeaping() then
		if owner:OnGround() or 0 < owner:WaterLevel() then
			self:SetLeaping(false)
			self:SetNextPrimaryFire(CurTime() + 0.8)
		else
			local trace, ent = self:CalcHit()

			if ent:IsValid() then
				local phys = ent:GetPhysicsObject()
				local damage = 18 + 18 * math.min(GetZombieFocus(owner:GetPos(), 300, 0.001, 0) - 0.3, 1)

				if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
					local vel = damage * 600 * owner:EyeAngles():Forward()

					phys:ApplyForceOffset(vel, (ent:NearestPoint(owner:GetShootPos()) + ent:GetPos() * 2) / 3)
					ent:SetPhysicsAttacker(owner)
				end

				self:SetLeaping(false)
				self:SetNextPrimaryFire(CurTime() + 1)
				owner:EmitSound("npc/headcrab_poison/ph_poisonbite"..math.random(1,3)..".wav")
				owner:ViewPunch(Angle(math.random(0, 30), math.random(0, 30), math.random(0, 30)))
				if ent:IsPlayer() and ent:Team() ~= owner:Team() then
					ent:TakeDamage(5, owner)
					local timername = tostring(ent).."poisonedby"..tostring(owner)
					timer.Create(timername, 2, math.random(7, 10), function()
						if IsValid(hitent) and IsValid(owner) then
							DoPoisoned(ent, owner, timername)
						end
					end)
					ent:SendLua("PoisEff()")
				else
					ent:TakeDamage(25, owner)
				end
			elseif trace.HitWorld then
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				self:SetLeaping(false)
				self:SetNextPrimaryFire(CurTime() + 1)
			end
		end
	end
end

function SWEP:PrimaryAttack()
	if self:IsLeaping() or self:IsGoingToSpit() then return end
	self:GetOwner():Fire("IgnoreFallDamage", "", 0)

	if CurTime() < self:GetNextLeap() then return end

	if not self:GetOwner():OnGround() then return end

	self:SetNextLeap(CurTime() + self.PounceWindUp)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:GetOwner():EmitSound("npc/headcrab_poison/ph_scream"..math.random(1,3)..".wav")

	self.RememberAngles = self:GetOwner():GetAngles()

	self:GetOwner():Freeze(true)
end

function SWEP:SecondaryAttack()
	if self:IsLeaping() or self:IsGoingToSpit() then return end

	if CurTime() < self:GetNextSpit() then return end

	self:SetNextSpit(CurTime() + self.SpitWindUp)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:GetOwner():EmitSound("npc/headcrab_poison/ph_scream"..math.random(1,3)..".wav")

	self:GetOwner():Freeze(true)
end

function SWEP:Reload()
	return false
end
