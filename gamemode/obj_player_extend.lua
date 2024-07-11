local meta = FindMetaTable("Player")
if not meta then return end

function meta:GetZombieClass()
	return self.Class or 1
end

function meta:SetZombieClass(cl)
	self.Class = cl
	local index = self:EntIndex()

	timer.Simple(1, function()
		BroadcastLua("ents.GetByIndex(" .. index .. ").Class="..cl)
	end)
end

function meta:TraceLine(distance, _mask)
	local vStart = self:GetShootPos()
	return util.TraceLine({start=vStart, endpos = vStart + self:GetAimVector() * distance, filter = self, mask = _mask})
end

--[[
hitData = {
	traceStartGet = nil, -- string ply callback name. Default "GetPos"
	traceStartExtraHeight = nil, -- number
	traceEndGetNormal = nil, -- string ply callback name. Default nil, then we use the ply weapon forward vec
	traceEndDistance = nil, -- number
	traceEndExtraHeight = nil, -- number
	traceMask = nil, -- MASK enum. Default MASK_SOLID
	hitScanHeight = nil, -- number
	hitScanRadius = nil, -- number
	upZThreshold = nil, -- number
	upZHeight = nil, -- number
	upZaimDistance = nil, -- number
	downZThreshold = nil, -- number
	downZHeight = nil, -- number
	downZaimDistance = nil, -- number
	midZHeight = nil, -- number
	midZaimDistance = nil -- number
}
]]
function meta:CalcMeleeHit(hitData)
	local tr = {}
	local vStart = self[hitData.traceStartGet or "GetPos"](self)
	local vEnd = hitData.traceEndGetNormal and self[hitData.traceEndGetNormal](self) or self:GetActiveWeapon():GetForward()

	tr.start = vStart + Vector(0, 0, hitData.traceStartExtraHeight)
	tr.endpos = vStart + vEnd * hitData.traceEndDistance + Vector(0, 0, hitData.traceEndExtraHeight)
	tr.filter = self
	tr.mask = hitData.traceMask or MASK_SOLID
	local trace = util.TraceLine(tr)
	local ent = trace.Entity

	if not ent:IsValid() or not trace.HitNonWorld then
		local curZ = self:GetForward().z
		local aimDistance

		if curZ > hitData.upZThreshold then
			curZ = Vector(0, 0, self:GetForward().z * hitData.upZHeight)
			aimDistance = hitData.upZaimDistance
		elseif curZ <= hitData.downZThreshold then
			curZ = Vector(0, 0, self:GetForward().z * hitData.downZHeight)
			aimDistance = hitData.downZaimDistance
		else
			curZ = Vector(0, 0, self:GetForward().z * hitData.midZHeight)
			aimDistance = hitData.midZaimDistance
		end		

		local searchPos = self:GetPos() + Vector(0, 0, hitData.hitScanHeight) + self:GetAimVector() * aimDistance + curZ

		for _, fin in ipairs(ents.FindInSphere(searchPos, hitData.hitScanRadius)) do
			if fin:IsPlayer() and fin:Team() ~= self:Team() and fin:Alive() then
				ent = fin
				break
			end
		end
	end

	if ent == nil then
		ent = NULL
	end

	return trace, ent
end

--[[
-- use sv_cheats 1 and thirdperson to see the generated areas
hook.Add("PostDrawTranslucentRenderables", "TestDamage", function()
	local owner = LocalPlayer()
	local wep = owner:GetActiveWeapon()

	if not wep:IsValid() or not wep.MeleeHitDetection or wep.MeleeHitDetection.hitScanHeight == nil then return end
	local hitData = wep.MeleeHitDetection
	local tr = {}
	local owner = wep:GetOwner()
	local vStart = owner[hitData.traceStartGet or "GetPos"](owner)
	local vEnd = hitData.traceEndGetNormal and owner[hitData.traceEndGetNormal](owner) or wep:GetForward()

	tr.start = vStart + Vector(0, 0, hitData.traceStartExtraHeight)
	tr.endpos = vStart + vEnd * hitData.traceEndDistance + Vector(0, 0, hitData.traceEndExtraHeight)
	tr.filter = owner
	tr.mask = hitData.traceMask or MASK_SOLID
	local trace = util.TraceLine(tr)
	local ent = trace.Entity

	render.DrawLine(tr.start, tr.endpos, Color(255, 0, 0))

	if IsValid(ent) then
		print("Detected trace", ent)
	end

	if not ent:IsValid() or not trace.HitNonWorld then
		local curZ = owner:GetForward().z
		local aimVectorMultiplier

		if curZ > hitData.upZThreshold then
			curZ = Vector(0, 0, owner:GetForward().z * hitData.upZHeight)
			aimDistance = hitData.upZaimDistance
		elseif curZ <= hitData.downZThreshold then
			curZ = Vector(0, 0, owner:GetForward().z * hitData.downZHeight)
			aimDistance = hitData.downZaimDistance
		else
			curZ = Vector(0, 0, owner:GetForward().z * hitData.midZHeight)
			aimDistance = hitData.midZaimDistance
		end

		local searchPos = owner:GetPos() + Vector(0, 0, hitData.hitScanHeight) + owner:GetAimVector() * aimDistance + curZ

		for _, fin in ipairs(ents.FindInSphere(searchPos, hitData.hitScanRadius)) do
			if fin:IsPlayer() and fin:Team() ~= owner:Team() and fin:Alive() then
				ent = fin
				print("Detected sphere", ent)
				break
			end
		end

		render.SetColorMaterial()
		render.DrawSphere(searchPos, hitData.hitScanRadius, 30, 30, Color(0, 175, 175, 100))
	end
end)
--]]

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

function meta:Redeem()
	for _, ply in ipairs(player.GetAll()) do
		ply:PrintMessage(3, self:Name().." redeemed themself.")
	end

	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
	util.Effect("redeem", effectdata)

	net.Start("PlayerRedeemed")
		net.WriteEntity(self)
	net.Broadcast()

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

//NDB
local btypes = {}
btypes[0] = "playergib"
btypes[1] = "playergib_zombieblooddye"
btypes[2] = "playergib_manablooddye"
btypes[3] = "playergib_rainbowblooddye"

function meta:Gib(dmginfo)
	local effectdata = EffectData()
		effectdata:SetEntity(self)
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetNormal(self:GetVelocity():GetNormalized())
	util.Effect("gib_player", effectdata, true, true)

	// NDB
	local mybtype = btypes[self:GetNetworkedInt("blooddye", 0)]

	local pos = self:GetPos() + Vector(0, 0, 32)
	local postwo = pos + Vector(0, 0, -22)
	for i=1, 2 do
		local ent = ents.Create(mybtype)
		if ent:IsValid() then
			ent:SetPos(pos + VectorRand() * 12)
			ent:SetAngles(VectorRand():Angle())
			ent:SetModel(HumanGibs[i])
			ent:Spawn()
		end
	end

	for i=1, 5 do
		local ent = ents.Create(mybtype)
		if ent:IsValid() then
			ent:SetPos(postwo + VectorRand() * 12)
			ent:SetAngles(VectorRand():Angle())
			local modelid = math.random(3, 7)
			ent:SetModel(HumanGibs[modelid])
			if mybtype == "playergib" and modelid > 4 then
				ent:SetMaterial("models/flesh")
			end
			ent:Spawn()
		end
	end
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
	local snds = ZombieClasses[self.Class].DeathSounds
	self:EmitSound(snds[math.random(1, #snds)])
end

function meta:PlayPainSound()
	if CurTime() < self.NextPainSound then return end
	self.NextPainSound = CurTime() + 0.2

	if self:Team() == TEAM_UNDEAD then
		local snds = ZombieClasses[self.Class].PainSounds
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

local FlinchSequences = {
	"flinch_01",
	"flinch_02",
	"flinch_back_01",
	"flinch_head_01",
	"flinch_head_02",
	"flinch_phys_01",
	"flinch_phys_02",
	"flinch_shoulder_l",
	"flinch_shoulder_r",
	"flinch_stomach_01",
	"flinch_stomach_02",
}
function meta:DoFlinchAnim(data)
	local seq = FlinchSequences[data] or FlinchSequences[1]
	if seq then
		local seqid = self:LookupSequence(seq)
		if seqid > 0 then
			self:AddVCDSequenceToGestureSlot(GESTURE_SLOT_FLINCH, seqid, 0, true)
		end
	end
end

local ZombieAttackSequences = {
	"zombie_attack_01",
	"zombie_attack_02",
	"zombie_attack_03",
	"zombie_attack_04",
	"zombie_attack_05",
	"zombie_attack_06"
}
function meta:DoZombieAttackAnim(data)
	local seq = ZombieAttackSequences[data] or ZombieAttackSequences[1]
	if seq then
		local seqid = self:LookupSequence(seq)
		if seqid > 0 then
			self:AddVCDSequenceToGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD, seqid, 0, true)
		end
	end
end

