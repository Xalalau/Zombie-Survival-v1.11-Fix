AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.SwapAnims = false

function SWEP:Deploy()
	local owner = self:GetOwner()
	owner:DrawViewModel(true)
	owner:DrawWorldModel(false)
	net.Start("RcHCScale")
		net.WriteEntity(owner)
	net.Send(owner)
end

function SWEP:Think()
	if not self.NextHit then return end
	if CurTime() < self.NextHit then return end
	self.NextHit = nil

	local ply = self:GetOwner()

	local trace, ent = ply:CalcMeleeHit(self.MeleeHitDetection)
	if not ent:IsValid() and self.PreHit and self.PreHit:IsValid() and self.PreHit:GetPos():Distance(ply:GetPos()) < 110 then
		ent = self.PreHit
		trace.Hit = true
	end
	
	local damage = 20 + 20 * math.min(GetZombieFocus(ply:GetPos(), 300, 0.001, 0) - 0.3, 1)

	if ent and ent:IsValid() then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local phys = ent:GetPhysicsObject()
			if ent:IsPlayer() then
				if ent:Team() == TEAM_UNDEAD then
					local vel = ply:GetAimVector() * 390
					vel.z = 95
					ent:SetVelocity(vel)
				end
			elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
				local vel = damage * 487 * ply:GetAimVector()

				phys:ApplyForceOffset(vel, (ent:NearestPoint(ply:GetShootPos()) + ent:GetPos() * 2) / 3)
				ent:SetPhysicsAttacker(ply)
			end
			ent:TakeDamage(damage, ply)
		end
	end

	if trace.Hit then
		ply:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
	end

	ply:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
	self.PreHit = nil
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	if self.SwapAnims then self:SendWeaponAnim(ACT_VM_HITCENTER) else self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
	self.SwapAnims = not self.SwapAnims
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:GetOwner():EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextHit = CurTime() + 0.4
	local trace, ent = self:GetOwner():CalcMeleeHit(self.MeleeHitDetection)
	if ent:IsValid() then
		self.PreHit = ent
	end
end
