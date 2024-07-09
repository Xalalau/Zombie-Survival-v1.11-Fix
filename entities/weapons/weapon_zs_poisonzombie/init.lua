AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Headcrabs = 2

function SWEP:SetThrowAnimTime(time)
	self:SetDTFloat(0, time)
end

function SWEP:Deploy()
	self:GetOwner():DrawViewModel(true)
	self:GetOwner():DrawWorldModel(false)
end

function SWEP:Think()
	if not self.NextHit then return end

	if self.NextSwingAnim and CurTime() > self.NextSwingAnim then
		if self.SwapAnims then self:SendWeaponAnim(ACT_VM_HITCENTER) else self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		self.SwapAnims = not self.SwapAnims
		self.NextSwingAnim = nil
	end

	if CurTime() < self.NextHit then return end

	local owner = self:GetOwner()

	self.NextHit = nil

	local trace, ent = self:CalcHit()
	if not ent and self.PreHit and self.PreHit:IsValid() and self.PreHit:GetPos():Distance(owner:GetShootPos()) < 135 then
		ent = self.PreHit
		trace.Hit = true
	end

	local damage = 45 + 45 * math.min(GetZombieFocus(owner:GetPos(), 300, 0.001, 0) - 0.3, 1)

	if ent and ent:IsValid() then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local phys = ent:GetPhysicsObject()
			if ent:IsPlayer() then
				if ent:Team() == TEAM_UNDEAD then
					local vel = owner:EyeAngles():Forward() * 500
					vel.z = 120
					ent:SetVelocity(vel)
				end
			elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
				local vel = damage * 600 * owner:EyeAngles():Forward()

				phys:ApplyForceOffset(vel, (ent:NearestPoint(owner:GetShootPos()) + ent:GetPos() * 2) / 3)
				ent:SetPhysicsAttacker(owner)
			end
			ent:TakeDamage(damage, owner)
		end
	end

 	if trace.Hit then
		owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 90, 80)
	end

	owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 90, 80)
	self.PreHit = nil
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:GetOwner():EmitSound("npc/zombie_poison/pz_warn"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextSwingAnim = CurTime() + 0.6
	self.NextHit = CurTime() + 1
	local trace, ent = self:CalcHit()
	if ent then
		self.PreHit = ent
	end
end

SWEP.NextYell = 0
function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	if self.Headcrabs <= 0 then
		self:GetOwner():EmitSound("npc/zombie_poison/pz_idle"..math.random(2,4)..".wav")
		self.NextYell = CurTime() + 2
		return
	end
	self:SetThrowAnimTime(CurTime() + self.ThrowAnimBaseTime)
	self:GetOwner():SetAnimation(PLAYER_SUPERJUMP)
	self:GetOwner():EmitSound("npc/zombie_poison/pz_throw"..math.random(2,3)..".wav")
	GAMEMODE:SetPlayerSpeed(self:GetOwner(), 1)
	self.NextYell = CurTime() + 4
	timer.Simple(1, function()
		if IsValid(self) and IsValid(self:GetOwner()) then
			ThrowHeadcrab(self:GetOwner(), self)
		end
	end)
end
