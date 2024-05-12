AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	GAMEMODE:WeaponDeployed(self.Owner, self)
	return true
end

function SWEP:Think()
	local ammocount = self.Owner:GetAmmoCount(self.Primary.Ammo)
	if 0 < ammocount then
		self:SetClip1(ammocount + self:Clip1())
		self.Owner:RemoveAmmo(ammocount, self.Primary.Ammo)
	end
end

function SWEP:Initialize()
	self:SetDeploySpeed(1.1)
	self.LastShootTime = 0
	self.NextNail = 0

	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_MELEE
	self.ActivityTranslate[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_MELEE
	self.ActivityTranslate[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_MELEE
	self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_MELEE
	self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_MELEE
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_MELEE
	self.ActivityTranslate[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_MELEE
	self.ActivityTranslate[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_MELEE
end

local NONAILS = {}
NONAILS[MAT_GRATE] = "Impossible."
NONAILS[MAT_CLIP] = "Impossible."
NONAILS[MAT_GLASS] = "Trying to put nails in glass is a silly thing to do."

function SWEP:SecondaryAttack()
	if 0 < self:Clip1() and self.NextNail < CurTime() then
		local tr = self.Owner:TraceLine(64)

		local trent = tr.Entity
		if not (trent:IsValid() and trent:GetMoveType() == MOVETYPE_VPHYSICS and util.IsValidPhysicsObject(trent, tr.PhysicsBone)) then return end
		if not trent:GetPhysicsObjectNum(tr.PhysicsBone):IsMoveable() then return end

		if NONAILS[tr.MatType or 0] then
			self.Owner:PrintMessage(HUD_PRINTCENTER, NONAILS[tr.MatType])
			return
		end

		local trtwo = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + self.Owner:GetAimVector() * 16, filter = {self.Owner, trent}})

		local ent = trtwo.Entity
		if trtwo.HitWorld or ent:IsValid() and string.find(ent:GetClass(), "prop_physics") and ent:GetPhysicsObject():IsMoveable() or ent:IsValid() and ent:GetClass() == "func_physbox" and ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:GetPhysicsObject():IsValid() and ent:GetPhysicsObject():IsMoveable() then
			if NONAILS[trtwo.MatType or 0] then
				self.Owner:PrintMessage(HUD_PRINTCENTER, NONAILS[trtwo.MatType])
				return
			end

			local cons = constraint.Weld(trent, ent, tr.PhysicsBone, trtwo.PhysicsBone, 0, true)
			if cons then -- New constraint
				self:SendWeaponAnim(ACT_VM_HITCENTER)
				self.Alternate = not self.Alternate
				self.Owner:SetAnimation(PLAYER_ATTACK1)

				self.NextNail = CurTime() + 1
				self:TakePrimaryAmmo(1)
				local nail = ents.Create("nail")
				local aimvec = self.Owner:GetAimVector()
				nail:SetPos(tr.HitPos - aimvec * 8)
				nail:SetAngles(aimvec:Angle())
				nail:SetParentPhysNum(tr.PhysicsBone)
				nail:SetParent(trent)
				nail:Spawn()
				trent:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1,4)..".wav")

				trent.Nails = trent.Nails or {}
				table.insert(trent.Nails, nail)

				nail.constraint = cons
				cons:DeleteOnRemove(nail)
			else -- Already constrained.
				for _, oldcons in pairs(constraint.FindConstraints(trent, "Weld")) do
					if oldcons.Ent1 == ent or oldcons.Ent2 == ent then
						trent.Nails = trent.Nails or {}
						if #trent.Nails < 5 then
							self:SendWeaponAnim(ACT_VM_HITCENTER)
							self.Alternate = not self.Alternate
							self.Owner:SetAnimation(PLAYER_ATTACK1)

							self.NextNail = CurTime() + 1
							self:TakePrimaryAmmo(1)
							local nail = ents.Create("nail")
							local aimvec = self.Owner:GetAimVector()
							nail:SetPos(tr.HitPos - aimvec * 8)
							nail:SetAngles(aimvec:Angle())
							nail:SetParentPhysNum(tr.PhysicsBone)
							nail:SetParent(trent)
							nail:Spawn()
							trent:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1,4)..".wav")

							table.insert(trent.Nails, nail)

							nail.constraint = oldcons.Constraint
							oldcons.Constraint:DeleteOnRemove(nail)
						--else
							--self.Owner:PrintMessage(HUD_PRINTCENTER, "Too many nails.")
						end
					end
				end
			end
		end
	end
end

local function StabCallback(attacker, trace, dmginfo)
	if trace.Hit and trace.HitPos:Distance(trace.StartPos) <= 62 then
		if trace.MatType == MAT_FLESH or trace.MatType == MAT_BLOODYFLESH or trace.MatType == MAT_ANTLION or trace.MatType == MAT_ALIENFLESH then
			util.Decal("Impact.Flesh", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		else
			util.Decal("Impact.Concrete", trace.HitPos + trace.HitNormal * 8, trace.HitPos - trace.HitNormal * 8)
		end

		attacker:EmitSound("weapons/melee/crowbar/crowbar_hit-"..math.random(1,4)..".wav")

		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_HITCENTER)

		local ent = trace.Entity
		if ent:IsValid() and trace.HitPos:Distance(trace.StartPos) <= 62 then
			--[[if ent:GetClass() == "nail" and not ent.Pounded then
				local tr = util.TraceLine({start = ent:GetPos(), endpos = ent:GetPos() + ent:GetForward() * 16, filter=ent})
				local hitent = tr.Entity
				if tr.HitNonWorld and hitent:IsValid() then
					local tr2 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + ent:GetForward() * 16, filter={ent, hitent}})
					local tr2hitent = tr2.Entity
					if tr2.HitWorld or tr2hitent:IsValid() and tr2hitent:GetPhysicsObject():IsValid() and tr2hitent:GetPhysicsObject():IsMoveable() and tr2hitent:GetMoveType() == MOVETYPE_VPHYSICS then
						ent.constraint:Remove()
						ent:SetPos(ent:GetPos() + ent:GetForward() * 8)
						ent:GetPhysicsObject():EnableMotion(false)
						ent:SetParent(hitent)
						local cons = constraint.Weld(hitent, tr2hitent, tr.PhysicsBone, tr2.PhysicsBone, 0, true)
						if cons then
							ent.constraint = cons
							ent:DeleteOnRemove(cons)
							cons:DeleteOnRemove(ent)
							ent.Pounded = true
						end

						hitent.Nails = hitent.Nails or {}
						table.insert(hitent.Nails, ent)
						if tr2hitent:IsValid() then
							tr2hitent.Nails = tr2hitent.Nails or {}
							table.insert(tr2hitent.Nails, ent)
							tr2hitent:DeleteOnRemove(ent)
						end
					end
				end
			end]]

			return {damage = true, effects = false}
		end
	else
		attacker:GetActiveWeapon():SendWeaponAnim(ACT_VM_MISSCENTER)
		attacker:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 80, math.random(75, 80))
	end

	return {effects = false, damage = false}
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

		self.Owner:SetAnimation(PLAYER_ATTACK1)

		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force = 5
		bullet.Damage = self.Primary.Damage
		bullet.HullSize = 1.75
		bullet.Callback = StabCallback
		self.Owner:FireBullets(bullet)
	end
end
