local meta = FindMetaTable( "Player" )
if not meta then return end

function meta:GetZombieClass()
	return self.Class or 1
	--return self:GetNetworkedInt("Class", 1)
end

function meta:SetZombieClass(cl)
	self.Class = cl
	--self:SetNetworkedInt("Class", cl)
end

function meta:TraceLine(distance)
	local vStart = self:GetShootPos()
	local trace = {}
	trace.start = vStart
	trace.endpos = vStart + (self:GetAimVector() * distance)
	trace.filter = self
	return util.TraceLine(trace)
end

function meta:Gib(dmginfo)
	if self.Class == 1 then
		local ent = ents.Create("env_shooter")
		if ent:IsValid() then
			ent:SetPos(self:GetPos() + Vector(0,0,48))
			ent:SetKeyValue("m_iGibs", 1)
			ent:SetKeyValue("m_flVelocity", 30)
			ent:SetKeyValue("shootmodel", "models/Zombie/Classic_legs.mdl")
			ent:SetKeyValue("m_flVariance", "5.0")
			ent:SetKeyValue("simulation", "2")
			ent:Spawn()
			ent:Fire("shoot", "", 0)
			ent:Fire("kill", "", 0.1)
		end
		ent = ents.Create("env_shooter")
		if ent:IsValid() then
			ent:SetPos(self:GetPos())
			ent:SetKeyValue("m_iGibs", 1)
			ent:SetKeyValue("m_flVelocity", 30)
			ent:SetKeyValue("shootmodel", "models/Zombie/Classic_torso.mdl")
			ent:SetKeyValue("m_flVariance", "5.0")
			ent:SetKeyValue("simulation", "2")
			ent:Spawn()
			ent:Fire("shoot", "", 0)
			ent:Fire("kill", "", 0.1)
		end
	elseif self.Class == 2 then
		local ent = ents.Create("env_shooter")
		if ent:IsValid() then
			ent:SetPos(self:GetPos() + Vector(0,0,48))
			ent:SetKeyValue("m_iGibs", 1)
			ent:SetKeyValue("m_flVelocity", 25)
			ent:SetKeyValue("shootmodel", "models/Gibs/Fast_Zombie_Legs.mdl")
			ent:SetKeyValue("m_flVariance", "5.0")
			ent:SetKeyValue("simulation", "2")
			ent:Spawn()
			ent:Fire("shoot", "", 0)
			ent:Fire("kill", "", 0.1)
		end
		ent = ents.Create("env_shooter")
		if ent:IsValid() then
			ent:SetPos(self:GetPos())
			ent:SetKeyValue("m_iGibs", 1)
			ent:SetKeyValue("m_flVelocity", 45)
			ent:SetKeyValue("shootmodel", "models/Gibs/Fast_Zombie_Torso.mdl")
			ent:SetKeyValue("m_flVariance", "5.0")
			ent:SetKeyValue("simulation", "2")
			ent:Spawn()
			ent:Fire("shoot", "", 0)
			ent:Fire("kill", "", 0.1)
		end
	elseif self.Class == 3 then
		local ent = ents.Create("env_shooter")
		if ent:IsValid() then
			ent:SetPos(self:GetPos())
			ent:SetKeyValue("m_iGibs", 1)
			ent:SetKeyValue("m_flVelocity", 45)
			ent:SetKeyValue("shootmodel", "models/Humans/Charple03.mdl")
			ent:SetKeyValue("m_flVariance", "5.0")
			ent:SetKeyValue("simulation", "2")
			ent:Spawn()
			ent:Fire("shoot", "", 0)
			ent:Fire("kill", "", 0.1)
		end
	end

	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetNormal(self:GetVelocity():Normalize())
	util.Effect("gib_player", effectdata)
end

function meta:LegsGib()
	self:EmitSound("physics/flesh/flesh_bloody_break.wav", 100, 75)
	local ent = ents.Create("prop_dynamic_override")
	if ent:IsValid() then
		ent:SetModel(Model("models/Zombie/Classic_legs.mdl"))
		ent:SetPos(self:GetPos())
		ent:SetAngles(self:GetAngles())
		ent:Spawn()
		ent:Fire("kill", "", 1.5)
	end
	local ent = ents.Create("env_shooter")
	if ent:IsValid() then
		ent:SetPos(self:GetPos())
		ent:SetKeyValue("gibangles", tostring(self:GetAngles()))
		ent:SetKeyValue("m_iGibs", "1")
		ent:SetKeyValue("m_flVelocity", 0)
		ent:SetKeyValue("shootmodel", "models/Zombie/Classic_legs.mdl")
		ent:SetKeyValue("m_flVariance", "0")
		ent:SetKeyValue("simulation", "2")
		ent:Spawn()
		ent:Fire("shoot", "", 1.5)
		ent:Fire("kill", "", 1.6)
	end
	self:Gib()
end

function meta:Redeem()
	for _, a in pairs(player.GetAll()) do
		a:PrintMessage(3, self:Name().." has redeemed themselves.")
	end
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
	util.Effect("redeem", effectdata)
	umsg.Start("PlayerRedeemed")
		umsg.Entity(self)
	umsg.End()
	self:StripWeapons()
	self:SetTeam(TEAM_HUMAN)
	self:Spawn()
	self:DrawViewModel(true)
	self:DrawWorldModel(true)
	self:SetFrags(0)
	self:SetDeaths(0)
	self.DeathClass = nil
	self.Class = 1
	self.SpawnedTime = CurTime()
	if self.Headcrabz then
		for _, headcrab in pairs(self.Headcrabz) do
			if headcrab:IsValid() and headcrab:IsNPC() then
				headcrab:Fire("sethealth", "0", 5)
			end
		end
	end
end

function meta:IsFemale()
	return self.Female
end

function meta:SetFemale()
	local model = self:GetModel() or "manlyman"
	if string.find(model, "female") or string.find(model, "alyx") or string.find(model, "mossman") then
		self.Female = true
	else
		self.Female = false
	end
end

function meta:PlayDeathSound()
    if self.Female then
		self:EmitSound(FemaleDeathSounds[math.random(1, #FemaleDeathSounds)])
    else
		self:EmitSound(MaleDeathSounds[math.random(1, #MaleDeathSounds)])
    end
end

function meta:PlayZombieDeathSound()
	self:EmitSound(ZombieClasses[self.Class].DeathSounds[math.random(1, #ZombieClasses[self.Class].DeathSounds)])
end

function meta:PlayPainSound()
	if CurTime() < self.NextPainSound then return end
	self.NextPainSound = CurTime() + 0.2
	if self:Team() == TEAM_UNDEAD then
		self:EmitSound(ZombieClasses[self.Class].PainSounds[math.random(1, #ZombieClasses[self.Class].PainSounds)])
	else
		local health = self:Health()
		if self.Female then
			if health > 68 then
				self:EmitSound(FemalePainSoundsLight[math.random(1, #FemalePainSoundsLight)])
			elseif health > 36 then
				self:EmitSound(FemalePainSoundsMed[math.random(1, #FemalePainSoundsMed)])
			else
				self:EmitSound(FemalePainSoundsHeavy[math.random(1, #FemalePainSoundsHeavy)])
			end
		else
			if health > 68 then
				self:EmitSound(MalePainSoundsLight[math.random(1, #MalePainSoundsLight)])
			elseif health > 36 then
				self:EmitSound(MalePainSoundsMed[math.random(1, #MalePainSoundsMed)])
			else
				self:EmitSound(MalePainSoundsHeavy[math.random(1, #MalePainSoundsHeavy)])
			end
		end
	end
end
