AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	self.DieTime = CurTime() + 7

	self:SetModel("models/props/cs_italy/orange.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetTrigger(true)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(4)
		phys:SetMaterial("metal")
		phys:EnableMotion(true)
		phys:Wake()
	end
end

function ENT:Think()
	if self.DieTime < CurTime() then
		if self.HitData then
			local data = self.HitData

			local hitent = data.HitEntity
			if hitent and hitent.SendLua and hitent:Team() ~= TEAM_UNDEAD then
				local owner = self:GetOwner()
				if owner and owner:IsValid() and owner:Team() == TEAM_UNDEAD then
					hitent:TakeDamage(10, owner, self)
				else
					hitent:TakeDamage(10, self, self)
				end

				local attach = hitent:GetAttachment(1)
				if attach then
					if data.HitPos:Distance(hitent:GetAttachment(1).Pos) < 25 then
						//hitent:SendLua("EyePoisoned()")
						if hitent.Female then
							hitent:EmitSound("vo/npc/Alyx/uggh02.wav")
						else
							hitent:EmitSound("vo/ravenholm/monk_death07.wav")
						end
						local timername = tostring(hitent).."poisonedby"..tostring(self)
						timer.Create(timername, 1, math.random(3, 5), DoPoisoned, hitent, owner, timername)
						umsg.Start("PoisonEffect", hitent)
						umsg.End()
					end
				end
			end

			self.Hit = nil
		end
		self:Remove()
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.HitData then return end

	self.HitData = data
	self.DieTime = 0

	local effectdata = EffectData()
		effectdata:SetOrigin(data.HitPos)
	util.Effect("spithit", effectdata)

	self:NextThink(CurTime())
	return true
end

function ENT:Touch(ent)
	if ent:IsPlayer() and ent ~= self:GetOwner() and not (ent:Team() == TEAM_UNDEAD and (ent.Class==6 or ent.Class==7 or ent.Class==8 or ent.Class==9)) then
		self:PhysicsCollide({HitEntity=ent, HitPos=self:GetPos()}, self:GetPhysicsObject())
	end
end

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS
end
