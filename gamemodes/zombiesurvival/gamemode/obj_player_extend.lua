local meta = FindMetaTable("Player")
if not meta then return end

function meta:GetZombieClass()
	return self.Class or 1
end

function meta:TraceLine(distance, _mask)
	local vStart = self:GetShootPos()
	return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask})
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

	self:Gib()
end

local oldspec = meta.Spectate
function meta:Spectate(obsm)
	self:StripWeapons()
	oldspec(self, obsm)
end

local oldunspec = meta.UnSpectate
function meta:UnSpectate()
	if self:GetMoveType() == MOVETYPE_OBSERVER then
		oldunspec(self, obsm)
	end
end

local oldalive = meta.Alive
function meta:Alive()
	if self:GetMoveType() == MOVETYPE_OBSERVER then return false end

	return oldalive(self)
end

function meta:Redeem()
	for _, a in pairs(player.GetAll()) do
		a:PrintMessage(3, self:Name().." redeemed themself.")
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
	self.LastAttacker = nil
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

local function SkullCam(pl, ent)
	if ent:IsValid() and pl:IsValid() then
		umsg.Start("SkullCam", pl)
			umsg.Entity(ent)
		umsg.End()
	end
end

local function realgib(self, pos, dmginfo)
	if not self:IsValid() then return end

	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(self:GetVelocity():Normalize())
		effectdata:SetScale(0)
	util.Effect("gib_player", effectdata, true, true)

	local mybtype = btypes[self:GetNetworkedInt("blooddye", 0)]

	pos = pos + Vector(0, 0, 32)
	local postwo = pos + Vector(0, 0, -22)
	for i=1, 2 do
		local ent = ents.Create(mybtype)
		if ent:IsValid() then
			ent:SetPos(pos + VectorRand() * 12)
			ent:SetAngles(VectorRand():Angle())
			ent:SetModel(HumanGibs[i])
			ent:Spawn()
			--[[if i == 1 then
				timer.Simple(0.2, SkullCam, self, ent)
			end]]
		end
	end

	for i=1, 4 do
		local ent = ents.Create(mybtype)
		if ent:IsValid() then
			ent:SetPos(postwo + VectorRand() * 12)
			ent:SetAngles(VectorRand():Angle())
			local modelid = math.random(3, 7)
			ent:SetModel(HumanGibs[modelid])
			if modelid > 4 then
				ent:SetMaterial("models/flesh")
			end
			ent:Spawn()
		end
	end
end

function meta:Gib(dmginfo)
	timer.Simple(0, realgib, self, self:GetPos(), dmginfo)
end

-- Male pain / death sounds
local VoiceSets = {}

VoiceSets["male"] = {}
VoiceSets["male"]["PainSoundsLight"] = {
Sound("vo/npc/male01/ow01.wav"),
Sound("vo/npc/male01/ow02.wav"),
Sound("vo/npc/male01/pain01.wav"),
Sound("vo/npc/male01/pain02.wav"),
Sound("vo/npc/male01/pain03.wav")
}

VoiceSets["male"]["PainSoundsMed"] = {
Sound("vo/npc/male01/pain04.wav"),
Sound("vo/npc/male01/pain05.wav"),
Sound("vo/npc/male01/pain06.wav")
}

VoiceSets["male"]["PainSoundsHeavy"] = {
Sound("vo/npc/male01/pain07.wav"),
Sound("vo/npc/male01/pain08.wav"),
Sound("vo/npc/male01/pain09.wav")
}

VoiceSets["male"]["DeathSounds"] = {
Sound("vo/npc/male01/no02.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_ohshit03.wav"),
Sound("vo/npc/Barney/ba_no01.wav"),
Sound("vo/npc/Barney/ba_no02.wav")
}

-- Female pain / death sounds
VoiceSets["female"] = {}
VoiceSets["female"]["PainSoundsLight"] = {
Sound("vo/npc/female01/pain01.wav"),
Sound("vo/npc/female01/pain02.wav"),
Sound("vo/npc/female01/pain03.wav")
}

VoiceSets["female"]["PainSoundsMed"] = {
Sound("vo/npc/female01/pain04.wav"),
Sound("vo/npc/female01/pain05.wav"),
Sound("vo/npc/female01/pain06.wav")
}

VoiceSets["female"]["PainSoundsHeavy"] = {
Sound("vo/npc/female01/pain07.wav"),
Sound("vo/npc/female01/pain08.wav"),
Sound("vo/npc/female01/pain09.wav")
}

VoiceSets["female"]["DeathSounds"] = {
Sound("vo/npc/female01/no01.wav"),
Sound("vo/npc/female01/ow01.wav"),
Sound("vo/npc/female01/ow02.wav")
}

VoiceSets["combine"] = {}
VoiceSets["combine"].PainSoundsLight = {
Sound("npc/combine_soldier/pain1.wav"),
Sound("npc/combine_soldier/pain2.wav"),
Sound("npc/combine_soldier/pain3.wav")
}

VoiceSets["combine"].PainSoundsMed = {
Sound("npc/metropolice/pain1.wav"),
Sound("npc/metropolice/pain2.wav")
}

VoiceSets["combine"].PainSoundsHeavy = {
Sound("npc/metropolice/pain3.wav"),
Sound("npc/metropolice/pain4.wav")
}

VoiceSets["combine"].DeathSounds = {
Sound("npc/combine_soldier/die1.wav"),
Sound("npc/combine_soldier/die2.wav"),
Sound("npc/combine_soldier/die3.wav")
}

function meta:PlayDeathSound()
	local snds = VoiceSets[self.VoiceSet].DeathSounds
	self:EmitSound(snds[math.random(1, #snds)])
end

function meta:PlayZombieDeathSound()
	local snds = self.ClassTable.DeathSounds
	self:EmitSound(snds[math.random(1, #snds)])
end

function meta:PlayPainSound()
	if CurTime() < self.NextPainSound then return end
	self.NextPainSound = CurTime() + 0.2

	if self:Team() == TEAM_UNDEAD then
		local snds = self.ClassTable.PainSounds
		self:EmitSound(snds[math.random(1, #snds)])
	else
		local health = self:Health()
		local set = VoiceSets[self.VoiceSet]

		if health > 68 then
			local snds = set.PainSoundsLight
			self:EmitSound(snds[math.random(1, #snds)])
		elseif health > 36 then
			local snds = set.PainSoundsMed
			self:EmitSound(snds[math.random(1, #snds)])
		else
			local snds = set.PainSoundsHeavy
			self:EmitSound(snds[math.random(1, #snds)])
		end
	end
end

if SERVER then
	meta.OldDrawViewModel = meta.DrawViewModel
	meta.OldDrawWorldModel = meta.DrawWorldModel

	function meta:DrawViewModel(bDraw)
		self.m_DrawViewModel = bDraw
		self:OldDrawViewModel(bDraw)
	end

	function meta:DrawWorldModel(bDraw)
		self.m_DrawWorldModel = bDraw
		self:OldDrawWorldModel(bDraw)
	end

	function meta:SetZombieClass(cl)
		self.Class = cl
		self.ClassTable = GAMEMODE.ZombieClasses[cl]
		if self.PostPlayerInitialSpawn then
			self:SendLua("MySelf:SetZombieClass("..cl..")")
		end
	end
end

if CLIENT then
	function meta:SetZombieClass(cl)
		self.Class = cl
		self.ClassTable = GAMEMODE.ZombieClasses[cl]
	end
end
