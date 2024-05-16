AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self:GetOwner():DrawViewModel(true)
	self:GetOwner():DrawWorldModel(true)
end

function SWEP:Initialize()
	self:SetWeaponHoldType("rpg")
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end

	local create = false
	local aimvec = self:GetOwner():GetAimVector()
	local shootpos = self:GetOwner():GetShootPos()
	local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self:GetOwner()})

	if tr.HitWorld then
		create = true
	else
		local right = aimvec:Angle():Right()
		local tr1 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * 42, filter = self:GetOwner()})
		local tr2 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * -42, filter = self:GetOwner()})
		if tr1.HitWorld or tr2.HitWorld then
			create = true
		end
	end

	if create then
		local ent = ents.Create("prop_physics")
		if ent:IsValid() then
			ent:SetPos(tr.HitPos)
			local angles = aimvec:Angle()
			angles.roll = 90
			ent:SetAngles(angles)
			ent:SetModel("models/props_debris/wood_board05a.mdl")
			ent:SetKeyValue("spawnflags", "1672")
			ent:Spawn()
			ent:Fire("sethealth", "450", 0)
			ent:EmitSound("npc/dog/dog_servo12.wav")
			ent:GetPhysicsObject():EnableMotion(false)
			self:TakePrimaryAmmo(1)
		end
	end
end

function SWEP:SecondaryAttack()
end
