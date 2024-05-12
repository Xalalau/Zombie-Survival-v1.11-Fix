AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

SWEP.Weight = 5
SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	self.Owner:DrawWorldModel(true)

	GAMEMODE:WeaponDeployed(self.Owner, self)

	return true
end

function SWEP:Initialize()
	self:SetWeaponHoldType("rpg")
	self:SetDeploySpeed(1.1)
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if self:CanPrimaryAttack() then
		local yaw = math.Clamp(tonumber(self.Owner:GetInfo("zs_barricadekityaw")), -180, 180)
		local create = false
		local aimvec = self.Owner:GetAimVector()
		local shootpos = self.Owner:GetShootPos()
		local tr = util.TraceLine({start = shootpos, endpos = shootpos + aimvec * 32, filter = self.Owner})

		if tr.HitWorld and not tr.HitSky then
			create = true
		else
			local right = aimvec:Angle():Right():Angle()
			right.pitch = yaw
			right = right:Forward()
			local tr1 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * 42, filter = self.Owner})
			local tr2 = util.TraceLine({start = tr.HitPos, endpos = tr.HitPos + right * -42, filter = self.Owner})
			if (tr1.HitWorld or tr2.HitWorld) and not tr1.HitSky and not tr2.HitSky then
				create = true
			end
		end

		if create then
			local ent = ents.Create("prop_physics")
			if ent:IsValid() then
				ent:SetPos(tr.HitPos)
				local angles = aimvec:Angle()
				angles.roll = math.NormalizeAngle(90 + yaw)
				ent:SetAngles(angles)
				ent:SetModel("models/props_debris/wood_board05a.mdl")
				ent:SetKeyValue("spawnflags", "1672")
				ent:Spawn()
				ent:Fire("sethealth", "450", 0)
				ent:EmitSound("npc/dog/dog_servo12.wav")
				ent:GetPhysicsObject():EnableMotion(false)
				self:TakePrimaryAmmo(1)
			end

			self:DefaultReload(ACT_VM_RELOAD)
		end
	end
end
