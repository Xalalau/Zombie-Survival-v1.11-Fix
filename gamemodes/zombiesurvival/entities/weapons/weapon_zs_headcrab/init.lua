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
	if self.Leaping then
		local owner = self.Owner
		if owner:OnGround() or 0 < owner:WaterLevel() then
			self.Leaping = false
			self.NextLeap = CurTime() + 0.75
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
					local damage = 5 -- + 2.5 * math.min(GetZombieFocus(owner:GetPos(), FOCUS_RANGE, 0.001, 0) - 0.3, 1)
					local phys = ent:GetPhysicsObject()

					if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
						local vel = damage * 600 * owner:GetAimVector()

						phys:ApplyForceOffset(vel, (ent:NearestPoint(vStart) + ent:GetPos() * 2) / 3)
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
			else
				self:NextThink(CurTime())
				return true
			end
		end
	end
end

SWEP.NextLeap = 0
function SWEP:PrimaryAttack()
	local owner = self.Owner
	if self.Leaping or CurTime() < self.NextLeap or not owner:OnGround() then return end
	owner:Fire("IgnoreFallDamage", "", 0)

	local vel = owner:GetAimVector()
	vel.z = math.max(0.45, vel.z)
	vel = vel:Normalize()

	local angles = owner:GetAngles():Forward()
	angles.z = 0
	angles = angles:Normalize()

	self.OwnerAngles = angles * 48
	self.OwnerOffset = Vector(0, 0, 14)
	owner:SetGroundEntity(NULL)
	owner:SetLocalVelocity(vel * 450)
	owner:EmitSound("npc/headcrab/attack"..math.random(1,3)..".wav")
	owner:RestartGesture(ACT_RANGE_ATTACK1)

	self.Leaping = true
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end

	self.Owner:EmitSound("npc/headcrab/idle"..math.random(1,3)..".wav")
	self.NextYell = CurTime() + 2
end

function SWEP:Reload()
	return false
end
