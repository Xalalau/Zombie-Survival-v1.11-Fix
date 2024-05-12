AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.ZombieOnly = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.SwapAnims = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(false)
	self.Owner.DeathClass = 1
end

function SWEP:Think()
	if not self.NextHit or CurTime() < self.NextHit then return end
	self.NextHit = nil

	local pl = self.Owner

	local vStart = pl:EyePos() + Vector(0, 0, -40)
	local trace = util.TraceLine({start=vStart, endpos = vStart + pl:GetAimVector() * 65, filter = pl, mask = MASK_SHOT})

	local ent
	if trace.HitNonWorld then
		ent = trace.Entity
	elseif self.PreHit and self.PreHit:IsValid() and not (self.PreHit:IsPlayer() and not self.PreHit:Alive()) and self.PreHit:GetPos():Distance(vStart) < 110 then
		ent = self.PreHit
		trace.Hit = true
	end

	if trace.Hit then
		pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
	end

	pl:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
	self.PreHit = nil

	if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local damage = 20 -- + 10 * math.min(GetZombieFocus(pl:GetPos(), FOCUS_RANGE, 0.001, 0) - 0.3, 1)
			local phys = ent:GetPhysicsObject()
			if ent:IsPlayer() then
				if ent:Team() == TEAM_UNDEAD then
					local vel = pl:GetAimVector() * 390
					vel.z = 95
					ent:SetVelocity(vel)
				end
			elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
				local vel = damage * 487 * pl:GetAimVector()

				phys:ApplyForceOffset(vel, (ent:NearestPoint(pl:GetShootPos()) + ent:GetPos() * 2) / 3)
				ent:SetPhysicsAttacker(pl)
			end
			ent:TakeDamage(damage, pl, self)
		end
	end
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	if self.SwapAnims then self:SendWeaponAnim(ACT_VM_HITCENTER) else self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	self.Owner:RestartGesture(ACT_MELEE_ATTACK1)
	self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextHit = CurTime() + 0.4
	local vStart = self.Owner:EyePos() + Vector(0, 0, -40)
	local trace = util.TraceLine({start=vStart, endpos = vStart + self.Owner:GetAimVector() * 65, filter = self.Owner, mask = MASK_SHOT})
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end
