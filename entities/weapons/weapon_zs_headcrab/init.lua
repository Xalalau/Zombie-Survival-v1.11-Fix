AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self:GetOwner():DrawViewModel(false)
	self:GetOwner():DrawWorldModel(false)
	umsg.Start("RcHCScale")
		umsg.Entity(self:GetOwner())
	umsg.End()
end

function SWEP:Think()
	if self.Leaping then
		local owner = self:GetOwner()
		if owner:OnGround() or 0 < owner:WaterLevel() then
			self.Leaping = false
			self.NextLeap = CurTime() + 0.75
		else
			local vStart = self:GetOwner():GetViewOffset() + owner:GetPos()
			local tr = {}
			tr.start = vStart
			tr.endpos = vStart + self:GetOwner():GetAngles()
			tr.filter = owner
			local trace = util.TraceLine(tr)
			local ent = trace.Entity

			for _, fin in ipairs(ents.FindInSphere(owner:GetShootPos() + owner:GetAimVector() * 15, 25)) do
				if fin:IsPlayer() and fin:Team() ~= owner:Team() and fin:Alive() then
					ent = fin
					break
				end
			end

			if ent:IsValid() then
				if ent:GetClass() == "func_breakable_surf" then
					ent:Fire("break", "", 0)
				else
					local damage = 6 + 6 * math.min(GetZombieFocus(owner:GetPos(), 300, 0.001, 0) - 0.3, 1)
					local phys = ent:GetPhysicsObject()

					if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
						local vel = damage * 600 * owner:GetAimVector()

						phys:ApplyForceOffset(vel, (ent:NearestPoint(owner:GetShootPos()) + ent:GetPos() * 2) / 3)
						ent:SetPhysicsAttacker(owner)
					end
					ent:TakeDamage(damage, owner)
				end
				self.Leaping = false
				self.NextLeap = CurTime() + 1
				owner:EmitSound("npc/headcrab/headbite.wav")
				owner:ViewPunch(Angle(math.random(0, 30), math.random(0, 30), math.random(0, 30)))
			elseif trace.HitWorld then
				owner:EmitSound("physics/flesh/flesh_strider_impact_bullet1.wav")
				self.Leaping = false
				self.NextLeap = CurTime() + 1
			end
		end
	end
end

SWEP.NextLeap = 0
function SWEP:PrimaryAttack()
	if self.Leaping or CurTime() < self.NextLeap or not self:GetOwner():OnGround() then return end
	self:GetOwner():Fire("IgnoreFallDamage", "", 0)

	local vel = self:GetOwner():GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel = vel:Normalize()

	local angles = self:GetOwner():GetAngles():Forward()
	angles.z = -0.1
	angles = angles:Normalize()

	self:GetOwner():SetViewOffset(angles * 48)
	self:GetOwner():SetAngles(Vector(0, 0, 6))
	self:GetOwner():SetGroundEntity(NULL)
	self:GetOwner():SetLocalVelocity(vel * 450)
	self:GetOwner():EmitSound("npc/headcrab/attack"..math.random(1,3)..".wav")
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)

	self.Leaping = true
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end

	self:GetOwner():EmitSound("npc/headcrab/idle"..math.random(1,3)..".wav")
	self.NextYell = CurTime() + 2
end

function SWEP:Reload()
	return false
end
