AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.ZombieOnly = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.Headcrabs = 2

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(false)
end

function SWEP:Think()
	if not self.NextHit then return end

	if self.NextSwingAnim and CurTime() > self.NextSwingAnim then
		if self.SwapAnims then self:SendWeaponAnim(ACT_VM_HITCENTER) else self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		self.SwapAnims = not self.SwapAnims
		self.NextSwingAnim = nil
	end

	if CurTime() < self.NextHit then return end

	self.NextHit = nil
	local trace = self.Owner:TraceLine(95, MASK_SHOT)
	local ent
	if trace.HitNonWorld then
		ent = trace.Entity
	elseif self.PreHit and self.PreHit:IsValid() and not (self.PreHit:IsPlayer() and not self.PreHit:Alive()) and self.PreHit:GetPos():Distance(self.Owner:GetShootPos()) < 135 then
		ent = self.PreHit
		trace.Hit = true
	end

	if trace.Hit then
		self.Owner:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav", 90, 80)
	end

	self.Owner:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav", 90, 80)
	self.PreHit = nil

	if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
		if ent:GetClass() == "func_breakable_surf" then
			ent:Fire("break", "", 0)
		else
			local damage = 45 -- + 22.5 * math.min(GetZombieFocus(self.Owner:GetPos(), FOCUS_RANGE, 0.001, 0) - 0.3, 1)
			local phys = ent:GetPhysicsObject()
			if ent:IsPlayer() then
				if ent:Team() == TEAM_UNDEAD then
					local vel = self.Owner:EyeAngles():Forward() * 500
					vel.z = 120
					ent:SetVelocity(vel)
				end
			elseif phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
				local vel = damage * 600 * self.Owner:EyeAngles():Forward()

				phys:ApplyForceOffset(vel, (ent:NearestPoint(self.Owner:GetShootPos()) + ent:GetPos() * 2) / 3)
				ent:SetPhysicsAttacker(self.Owner)
			end
			ent:TakeDamage(damage, self.Owner)
		end
	end
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
	if CurTime() < self.NextSwing then return end
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	self.Owner:RestartGesture(ACT_MELEE_ATTACK1)
	self.Owner:EmitSound("npc/zombie_poison/pz_warn"..math.random(1, 2)..".wav")
	self.NextSwing = CurTime() + self.Primary.Delay
	self.NextSwingAnim = CurTime() + 0.6
	self.NextHit = CurTime() + 1
	local trace = self.Owner:TraceLine(95, MASK_SHOT)
	if trace.HitNonWorld then
		self.PreHit = trace.Entity
	end
end

function SWEP:Reload()
	return false
end

SWEP.NextYell = 0

local function DoPuke(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		GAMEMODE:SetPlayerSpeed(pl, pl.ClassTable.Speed)

		local shootpos = pl:GetShootPos()
		local startpos = pl:GetPos()
		startpos.z = shootpos.z
		local aimvec = pl:GetAimVector()
		aimvec.z = math.max(aimvec.z, -0.7)
		for i=1, 8 do
			local ent = ents.Create("projectile_poisonpuke")
			if ent:IsValid() then
				local heading = (aimvec + VectorRand() * 0.2):Normalize()
				ent:SetPos(startpos + heading * 8)
				ent:SetOwner(pl)
				ent:Spawn()
				ent.TeamID = pl:Team()
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous(heading * math.Rand(300, 550))
				end
				ent:SetPhysicsAttacker(pl)
			end
		end

		pl:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 80, math.random(70, 80))

		pl:TakeDamage(40, pl, wep)
	end
end

local function DoSwing(pl, wep)
	if pl:IsValid() and pl:Alive() and wep:IsValid() then
		pl:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav", 80, math.random(70, 83))
		if wep.SwapAnims then wep:SendWeaponAnim(ACT_VM_HITCENTER) else wep:SendWeaponAnim(ACT_VM_SECONDARYATTACK) end
		wep.SwapAnims = not wep.SwapAnims
	end
end

function SWEP:SecondaryAttack()
	if CurTime() < self.NextYell then return end
	if self.Owner:Team() ~= TEAM_UNDEAD then self.Owner:Kill() return end
	self.Owner:RestartGesture(ACT_RANGE_ATTACK2)
	self.Owner:EmitSound("npc/zombie_poison/pz_throw"..math.random(2,3)..".wav")
	GAMEMODE:SetPlayerSpeed(self.Owner, 1)
	self.NextYell = CurTime() + 4
	--timer.Simple(1, ThrowHeadcrab, self.Owner, self)
	timer.Simple(0.6, DoSwing, self.Owner, self)
	timer.Simple(1, DoPuke, self.Owner, self)
end
