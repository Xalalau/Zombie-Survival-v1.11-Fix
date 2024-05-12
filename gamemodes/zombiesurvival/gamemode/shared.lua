include("obj_player_extend.lua")
include("obj_weapon_extend.lua")
include("obj_entity_extend.lua")

GM.Rewards = {}
GM.STARTLOADOUTS = {}
GM.AmmoRegeneration = {}
GM.AmmoCache = {}
GM.ZombieClasses = {}
GM.RestrictedModels = {}
GM.AmmoTranslations = {}

function RegisterZombieClass(name, tab)
	local gm = GAMEMODE or GM

	tab.Wave = math.floor(tab.Wave * NUM_WAVES)
	table.insert(gm.ZombieClasses, tab)
	tab.Index = #gm.ZombieClasses

	gm.ZombieClasses[name] = gm.ZombieClasses[tab.Index]
end

include("zs_options.lua")

if SinglePlayer() then
	USE_NPCS = true
	NPCS_COUNT_AS_KILLS = true
	WARMUP_MODE = false
elseif MaxPlayers() < WARMUP_THRESHOLD then
	WARMUP_MODE = false
end

INFLICTION = 0

TEAM_ZOMBIE = 3
TEAM_UNDEAD = TEAM_ZOMBIE
TEAM_SURVIVORS = 4
TEAM_HUMAN = TEAM_SURVIVORS

team.SetUp(TEAM_ZOMBIE, "The Undead", Color(0, 255, 0))
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(0, 160, 255))

HumanGibs = {Model("models/gibs/HGIBS.mdl"),
Model("models/gibs/HGIBS_spine.mdl"),
Model("models/gibs/HGIBS_rib.mdl"),
Model("models/gibs/HGIBS_scapula.mdl"),
Model("models/gibs/antlion_gib_medium_2.mdl"),
Model("models/gibs/Antlion_gib_Large_1.mdl"),
Model("models/gibs/Strider_Gib4.mdl")
}

util.PrecacheSound("physics/body/body_medium_break2.wav")
util.PrecacheSound("physics/body/body_medium_break3.wav")
util.PrecacheSound("physics/body/body_medium_break4.wav")
util.PrecacheSound("ambient/energy/whiteflash.wav")
util.PrecacheModel("models/props_debris/wood_board05a.mdl")
util.PrecacheModel("models/player/alyx.mdl")
util.PrecacheModel("models/player/barney.mdl")
util.PrecacheModel("models/player/breen.mdl")
util.PrecacheModel("models/player/combine_soldier.mdl")
util.PrecacheModel("models/player/combine_soldier_prisonguard.mdl")
util.PrecacheModel("models/player/combine_super_soldier.mdl")
util.PrecacheModel("models/player/eli.mdl")
util.PrecacheModel("models/player/gman_high.mdl")
util.PrecacheModel("models/player/Kleiner.mdl")
util.PrecacheModel("models/player/monk.mdl")
util.PrecacheModel("models/player/mossman.mdl")
util.PrecacheModel("models/player/odessa.mdl")
util.PrecacheModel("models/player/police.mdl")
util.PrecacheModel("models/player/female_04.mdl")
util.PrecacheModel("models/player/female_06.mdl")
util.PrecacheModel("models/player/female_07.mdl")
util.PrecacheModel("models/player/male_02.mdl")
util.PrecacheModel("models/player/male_03.mdl")
util.PrecacheModel("models/player/male_08.mdl")
util.PrecacheModel("models/player/classic.mdl")
util.PrecacheModel("models/player/corpse1.mdl")
util.PrecacheModel("models/player/charple01.mdl")

ENDROUND = false
HALFLIFE = false
UNLIFE = false

VecRand = VectorRand

DISMEMBER_HEAD = 2
DISMEMBER_LEFTARM = 4
DISMEMBER_RIGHTARM = 8
DISMEMBER_LEFTLEG = 16
DISMEMBER_RIGHTLEG = 32

function GetZombieFocus(mypos, range, multiplier, maxper)
	local zombies = 0
	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD and pl:Alive() then
			local dist = pl:GetPos():Distance(mypos)
			if dist <= range then
				zombies = zombies + math.max((range - dist) * multiplier, maxper)
			end
		end
	end

	if UNLIFE then
		return math.max(0.75, math.min(zombies, 1))
	elseif HALFLIFE then
		return math.max(0.5, math.min(zombies, 1))
	else
		return math.min(zombies, 1)
	end
end

function GM:GetRagdollEyes(pl)
	local Ragdoll = pl:GetRagdollEntity()
	if not Ragdoll then return end

	local att = Ragdoll:GetAttachment(Ragdoll:LookupAttachment("eyes"))
	if att then
		local ct = CurTime()
		local RotateAngle = Angle(math.sin(ct * 0.5) * 30, math.cos(ct * 0.5) * 30, math.sin(ct) * 30)

		att.Pos = att.Pos + att.Ang:Forward()
		att.Ang = att.Ang

		return att.Pos, att.Ang
	end
end

function GM:SetPlayerSpeed(pl, walk)
	pl.WalkSpeed = walk
	pl:SetWalkSpeed(walk)
	pl:SetRunSpeed(walk)
	pl:SetMaxSpeed(walk)
end

function GM:GetWaveEnd()
	return GetGlobalFloat("waveend", 0)
end

GM.WaveEnd = 0
function GM:SetWaveEnd(wav)
	SetGlobalFloat("waveend", wav)
	self.WaveEnd = wav
	if SERVER and wav == 1 then
		self:SetRandomsToZombie()
	end
end

function GM:GetWaveStart()
	return GetGlobalFloat("wavestart", WAVEZERO_LENGTH)
end

GM.WaveStart = 0
function GM:SetWaveStart(wav)
	SetGlobalFloat("wavestart", wav)
	self.WaveStart = wav
end

function GM:GetWave()
	return GetGlobalInt("wave", 0)
end

GM.Wave = 0
function GM:SetWave(wav)
	SetGlobalInt("wave", wav)
	self.Wave = wav
end

if GM:GetWave() == 0 then
	GM:SetWaveStart(WAVEZERO_LENGTH)
	GM:SetWaveEnd(WAVEZERO_LENGTH + WAVEONE_LENGTH)
end

function GM:GetFighting()
	return GetGlobalBool("fighting", false)
end

--[[local function NoColliding()
	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD and pl:GetCollisionGroup() == COLLISION_GROUP_DEBRIS then
			pl:SetCollisionGroup(COLLISION_GROUP_PLAYER)
		end
	end
end]]

function GM:SetFighting(bfight)
	if ENDROUND then return end

	local changing = self:GetFighting() ~= bfight

	SetGlobalBool("fighting", bfight)
	self.Fighting = bfight

	if SERVER and changing then
		if bfight then
			if self:GetWave() == 0 then
				self:SetRandomsToZombie()
			end

			self:SetWave(self:GetWave() + 1)
			self:SetWaveStart(CurTime())
			self:SetWaveEnd(self:GetWaveStart() + WAVEONE_LENGTH + (self:GetWave() - 1) * WAVE_TIMEADD)

			umsg.Start("recwavestart")
				umsg.Short(self:GetWave())
				umsg.Float(self:GetWaveEnd())
			umsg.End()

			--[[if 1 < self:GetWave() then
				self:AmmoRegenerate()
			end]]

			for _, pl in pairs(player.GetAll()) do
				if pl:Team() == TEAM_UNDEAD and not pl:Alive() then
					pl:UnSpectate()
					pl:Spawn()
					--pl:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				end
			end

			--timer.Simple(3.5, NoColliding)
		elseif self:GetWave() == NUM_WAVES then
			self:EndRound(TEAM_HUMAN)
		else
			self:SetWaveStart(CurTime() + WAVE_INTERMISSION_LENGTH)

			umsg.Start("recwaveend")
				umsg.Short(self:GetWave())
				umsg.Float(self:GetWaveStart())
			umsg.End()

			for _, pl in pairs(player.GetAll()) do
				--if pl:Team() == TEAM_UNDEAD and pl:GetMoveType() ~= MOVETYPE_OBSERVER then
				if pl:Team() == TEAM_UNDEAD and not pl:Alive() and pl:GetMoveType() ~= MOVETYPE_OBSERVER then
					pl:SetHealth(100)
					pl:Spectate(OBS_MODE_ROAMING)
				end
			end
		end
	end
end

function GM:AFKKicker(pl)
	return pl:Team() == TEAM_UNDEAD and team.NumPlayers(TEAM_UNDEAD) == 1
end

GM.LivingZombies = 0

function GM:GetZombieLives()
	return team.GetScore(TEAM_UNDEAD)
end

function GM:SetZombieLives(int)
	team.SetScore(TEAM_UNDEAD, int)
end

function GM:GetGameDescription()
	if DISPLAY_WAVES_ON_SERVERLIST then
		return self.Name.." v"..string.format("%.2f", self.Version).." "..self.SubVersion.." (Wave "..self:GetWave().." of "..NUM_WAVES..")"
	else
		return self.Name.." v"..string.format("%.2f", self.Version).." "..self.SubVersion
	end
end

function GM:PlayerTraceAttack(pl, dmginfo, dir, trace)
	return false
end

function GM:PlayerFootstep(pl, vPos, iFoot, strSoundName, fVolume, pFilter)
end

function GM:PlayerStepSoundTime(pl, iType, bWalking)
	local fStepTime = 350

	if iType == STEPSOUNDTIME_NORMAL or iType == STEPSOUNDTIME_WATER_FOOT then
		local fMaxSpeed = pl:GetMaxSpeed()
		if fMaxSpeed <= 100 then
			fStepTime = 400
		elseif fMaxSpeed <= 300 then
			fStepTime = 350
		else
			fStepTime = 250
		end
	elseif iType == STEPSOUNDTIME_ON_LADDER then
		fStepTime = 450
	elseif iType == STEPSOUNDTIME_WATER_KNEE then
		fStepTime = 600
	end

	if pl:Crouching() then
		fStepTime = fStepTime + 50
	end

	return fStepTime
end

-- Put down here so I know for sure that when someone has a higher version number than I released that they're definitely an idiot.
GM.Name = "Zombie Survival"
GM.Version = 2.0
GM.Author = "William \"JetBoom\" Moodhe"
GM.Email = "jetboom@yahoo.com"
GM.Website = "http://www.noxiousnet.com"

GM.Credits = {
{"William \"JetBoom\" Moodhe", "http://noxiousnet.com (jetboom@yahoo.com)", "Project Lead / Programmer"},
{"11k", "tjd113@gmail.com", "Zombie weapon view models"},
{"Survival Crisis Z", "http://skasoftware.com/", "Human ambient beat sounds"},
{"Zombie Panic Source", "http://www.zombiepanic.org/", "Melee weapon models"},
{"AzuiSleet", "azuisleet@gmail.com", "Collision hook module"}
}
