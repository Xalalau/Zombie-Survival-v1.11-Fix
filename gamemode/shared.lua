-- HACK: force init the cvars when the gamemode is not installed in the client!
--       they don't init even if he downloads the gamemode while joining the server.
--       after creating the cvars locally I get their real values from the server - Xala
ZSPlzFixCvars = {
	["zs_difficulty"] = 1, -- temp values
	["zs_warmup_mode"] = 1,
	["zs_warmup_threshold"] = 2,
	["zs_allow_map_npcs"] = 0,
	["zs_npcs_count_as_kills"] = 0,
	["zs_allow_redeeming"] = 1,
	["zs_autoredeem"] = 1,
	["zs_redeem_kills"] = 3,
	["zs_ammo_regenerate_rate"] = 75,
	["zs_roundtime"] = 720,
	["zs_intermission_time"] = 35,
	["zs_human_deadline"] = 1,
	["zs_destroy_doors"] = 1,
	["zs_destroy_prop_doors"] = 0,
	["zs_anti_vent_camp"] = 1,
	["zs_allow_shove"] = 1,
	["zs_allow_admin_noclip"] = 1,
	["zs_rewards_1"] = 2,
	["zs_rewards_2"] = 4,
	["zs_rewards_3"] = 6,
	["zs_rewards_4"] = 8,
	["zs_rewards_5"] = 10,
	["zs_rewards_6"] = 12,
	["zs_rewards_7"] = 14
}

local neededToFixCvars = false

for cvarName, cvarDefault in pairs(ZSPlzFixCvars) do
	if not GetConVar(cvarName) then
		CreateConVar(cvarName, cvarDefault, { FCVAR_ARCHIVE, FCVAR_REPLICATED })
		neededToFixCvars = true
	end
end

net.Receive("FixClCvars", function()
	if not neededToFixCvars then return end

	local cvarTab = net.ReadTable()

	for cvarName, cvarValue in pairs(ZSPlzFixCvars) do
		RunConsoleCommand(cvarName, cvarValue)
	end
end)

--- --------------------------------------------------------------

include("obj_player_extend.lua")
include("obj_weapon_extend.lua")
include("zs_options.lua")
include("animations.lua")

-- This stuff isn't for you to change. You should only edit the stuff in zs_options.lua
GM.Name = "Zombie Survival "..GM.Version.." "..GM.SubVersion
GM.Author = "JetBoom"
GM.Email = "jetboom@yahoo.com"
GM.Website = "www.noxiousnet.com"

-- Same as above.
-- if SERVER and GM.SubVersion == "Official" and util.CRC(file.Read("../gamemodes/zombiesurvival/gamemode/zs_options.lua")) ~= "1897461897" then
-- 	GM.SubVersion = "Modified"
-- 	GM.Name = "Zombie Survival "..GM.Version.." "..GM.SubVersion
-- end -- There's no use for this anymore - Xala

INFLICTION = 0

TEAM_ZOMBIE = 3
TEAM_UNDEAD = TEAM_ZOMBIE
TEAM_SURVIVORS = 4
TEAM_HUMAN = TEAM_SURVIVORS

team.SetUp(TEAM_ZOMBIE, "The Undead", Color(0, 255, 0))
team.SetUp(TEAM_SURVIVORS, "Survivors", Color(0, 160, 255))

HumanGibs = {
	"models/gibs/HGIBS.mdl",
	"models/gibs/HGIBS_spine.mdl",
	"models/gibs/HGIBS_rib.mdl",
	"models/gibs/HGIBS_scapula.mdl",
	"models/gibs/antlion_gib_medium_2.mdl",
	"models/gibs/Antlion_gib_Large_1.mdl",
	"models/gibs/Strider_Gib4.mdl"
}

HumanTorsos = {
	"models/Gibs/Fast_Zombie_Torso.mdl",
	"models/Zombie/Classic_torso.mdl",
	"models/Humans/Charple03.mdl"
}

HumanLegs = {
	"models/Zombie/Classic_legs.mdl",
	"models/Gibs/Fast_Zombie_Legs.mdl"
}

for i=2, 4 do
	util.PrecacheSound("physics/body/body_medium_break"..i..".wav")
end

util.PrecacheSound("ambient/energy/whiteflash.wav")

for k, v in ipairs(HumanGibs) do
	util.PrecacheModel(v)
end
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

function GetZombieFocus(mypos, range, multiplier, maxper)
	local zombies = 0
	for _, ply in ipairs(player.GetHumans()) do
		if ply:Team() == TEAM_UNDEAD and ply:Alive() then
			local dist = ply:GetPos():Distance(mypos)
			if dist < range then
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

function GM:SetPlayerSpeed(ply, walk)
	ply.WalkSpeed = walk
	ply:SetWalkSpeed(walk)
	ply:SetRunSpeed(walk)
end

// Slower reverse speed.
function GM:Move(ply, move)
	if ply:Team() == TEAM_HUMAN then
		local speed = move:GetForwardSpeed()
		local sidespeed = move:GetSideSpeed()
		if speed < 0 and speed - math.abs(sidespeed) < -130 then // They're walking backwards but don't slow down already slow weapons.
			move:SetForwardSpeed(speed * 0.666) // Fraction it.
			move:SetSideSpeed(sidespeed * 0.666) // Also fraction this.
		end
	end
end

function GM:GetGameDescription()
	return self.Name
end

function GM:PlayerTraceAttack(ply, dmginfo, dir, trace)
	return false
end
