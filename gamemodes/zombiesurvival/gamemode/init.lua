AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

AddCSLuaFile("cl_spawnmenu.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_spawnmenu.lua")
AddCSLuaFile("cl_hudpickup.lua")
AddCSLuaFile("cl_targetid.lua")
AddCSLuaFile("cl_scoreboard.lua" )
AddCSLuaFile("cl_postprocess.lua")
AddCSLuaFile("cl_deathnotice.lua")
AddCSLuaFile("gravitygun.lua")

AddCSLuaFile("obj_player_extend.lua")
AddCSLuaFile("obj_weapon_extend.lua")

AddCSLuaFile("zs_options.lua")

AddCSLuaFile("scoreboard/scoreboard.lua")

include("shared.lua")
include("powerups.lua")

if file.Exists("../gamemodes/zombiesurvival/gamemode/maps/"..game.GetMap()..".lua") then
	include("maps/"..game.GetMap()..".lua")
end

function gmod.BroadcastLua(lua)
	for _, pl in pairs(player.GetAll()) do
		pl:SendLua(lua)
	end
end

GM.PlayerSpawnTime = {}

LASTHUMAN = false
CAPPED_INFLICTION = 0

function GM:Initialize()
	resource.AddFile("sound/ecky.wav")
	resource.AddFile("sound/beat9.wav")
	resource.AddFile("sound/beat8.wav")
	resource.AddFile("sound/beat7.wav")
	resource.AddFile("sound/beat6.wav")
	resource.AddFile("sound/beat5.wav")
	resource.AddFile("sound/beat4.wav")
	resource.AddFile("sound/beat3.wav")
	resource.AddFile("sound/beat2.wav")
	resource.AddFile("sound/beat1.wav")
	resource.AddFile("materials/zombohead.vmt")
	resource.AddFile("materials/zombohead.vtf")
	resource.AddFile("materials/humanhead.vmt")
	resource.AddFile("materials/humanhead.vtf")
	resource.AddFile("materials/killicon/zs_zombie.vtf")
	resource.AddFile("materials/killicon/zs_zombie.vmt")
	resource.AddFile("materials/killicon/redeem.vtf")
	resource.AddFile("materials/killicon/redeem.vmt")
	resource.AddFile("models/Weapons/v_zombiearms.mdl")
	resource.AddFile("models/Weapons/v_zombiearms.vvd")
	resource.AddFile("models/Weapons/v_zombiearms.sw.vtx")
	resource.AddFile("models/Weapons/v_zombiearms.dx90.vtx")
	resource.AddFile("models/Weapons/v_zombiearms.dx80.vtx")
	resource.AddFile("materials/Models/Weapons/v_zombiearms/Zombie_Classic_sheet.vmt")
	resource.AddFile("materials/Models/Weapons/v_zombiearms/Zombie_Classic_sheet.vtf")
	resource.AddFile("materials/Models/Weapons/v_zombiearms/Zombie_Classic_sheet_normal.vtf")
	resource.AddFile("models/Weapons/v_fza.mdl")
	resource.AddFile("models/Weapons/v_fza.vvd")
	resource.AddFile("models/Weapons/v_FZA.sw.vtx")
	resource.AddFile("models/Weapons/v_FZA.dx90.vtx")
	resource.AddFile("models/Weapons/v_FZA.dx80.vtx")
	resource.AddFile("materials/Models/Weapons/v_fza/fast_zombie_sheet.vmt")
	resource.AddFile("materials/Models/Weapons/v_fza/fast_zombie_sheet.vtf")
	resource.AddFile("materials/Models/Weapons/v_fza/fast_zombie_sheet_normal.vtf")
	resource.AddFile("sound/"..LASTHUMANSOUND)
	resource.AddFile("sound/"..ALLLOSESOUND)
	resource.AddFile("sound/"..HUMANWINSOUND)
	resource.AddFile("sound/"..DEATHSOUND)
end

function GM:ShowHelp(pl)
	pl:SendLua("GAMEMODE:ScoreboardShow() SCOREBOARD:SetMode(3)")
end

local function GlitchedShowHelpAlias(sender, command, arguments)
	GAMEMODE:ShowHelp(sender)
end
concommand.Add("gm_help", GlitchedShowHelpAlias)

function GM:ShowTeam(pl)
	if not REDEEM then return end
	if AUTOREDEEM then return end
	if pl:Team() ~= TEAM_UNDEAD then return end
	if pl:Frags() < REDEEM_KILLS then return end
	pl:Redeem()
end

function GM:ShowSpare1(pl)
	pl:SendLua("GAMEMODE:ScoreboardShow() SCOREBOARD:SetMode(2)")
end

HEAD_NPC_SCALE = math.Clamp(3 - DIFFICULTY, 1.5, 4)
function GM:InitPostEntity()
	self.UndeadSpawnPoints = {}
	self.UndeadSpawnPoints = ents.FindByClass("info_player_undead")
	self.UndeadSpawnPoints = table.Add(self.UndeadSpawnPoints, ents.FindByClass("info_player_zombie"))
	self.UndeadSpawnPoints = table.Add(self.UndeadSpawnPoints, ents.FindByClass("info_player_rebel"))

	self.HumanSpawnPoints = {}
	self.HumanSpawnPoints = ents.FindByClass("info_player_human")
	self.HumanSpawnPoints = table.Add( self.HumanSpawnPoints, ents.FindByClass("info_player_combine"))

	local mapname = game.GetMap()
	-- Terrorist spawns are usually in some kind of house or a main base in CS_  in order to guard the hosties. Put the humans there.
	if string.find(mapname, "cs_") or string.find(mapname, "zs_") then
		self.UndeadSpawnPoints = table.Add(self.UndeadSpawnPoints, ents.FindByClass("info_player_counterterrorist"))
		self.HumanSpawnPoints = table.Add( self.HumanSpawnPoints, ents.FindByClass("info_player_terrorist"))
	else -- Otherwise, this is probably a DE_, ZM_, or ZH_ map. In DE_ maps, the T's spawn away from the main part of the map and are zombies in zombie plugins so let's do the same.
		self.UndeadSpawnPoints = table.Add(self.UndeadSpawnPoints, ents.FindByClass("info_player_terrorist"))
		self.HumanSpawnPoints = table.Add(self.HumanSpawnPoints, ents.FindByClass("info_player_counterterrorist"))
	end

	-- Add all the old ZS spawns.
	for _, oldspawn in pairs(ents.FindByClass("gmod_player_start")) do
		if oldspawn.BlueTeam then
			table.insert(self.HumanSpawnPoints, oldspawn)
		else
			table.insert(self.UndeadSpawnPoints, oldspawn)
		end
	end

	-- You shouldn't play a DM map since spawns are shared but whatever. Let's make sure that there aren't team spawns first.
	if #self.HumanSpawnPoints <= 0 then
		self.HumanSpawnPoints = ents.FindByClass("info_player_start")
	end
	if #self.UndeadSpawnPoints <= 0 then
		self.UndeadSpawnPoints = ents.FindByClass("info_player_start")
	end

	game.ConsoleCommand("sk_zombie_health "..math.ceil(50 + 50 * DIFFICULTY).."\n")
	game.ConsoleCommand("sk_zombie_dmg_one_slash "..math.ceil(20 + DIFFICULTY * 10).."\n")
	game.ConsoleCommand("sk_zombie_dmg_both_slash "..math.ceil(30 + DIFFICULTY * 12).."\n")

	local destroying = ents.FindByClass("prop_ragdoll") // These seem to cause server crashes if a zombie attacks them. They cause pointless lag, too.
	if not USE_NPCS then
		destroying = table.Add(destroying, ents.FindByClass("npc_zombie"))
		destroying = table.Add(destroying, ents.FindByClass("npc_maker"))
		destroying = table.Add(destroying, ents.FindByClass("npc_template_maker"))
		destroying = table.Add(destroying, ents.FindByClass("npc_maker_template"))
	end
	if DESTROY_DOORS then
		destroying = table.Add(destroying, ents.FindByClass("func_door_rotating"))
		destroying = table.Add(destroying, ents.FindByClass("func_door"))
	end
	if DESTROY_PROP_DOORS then
		destroying = table.Add(destroying, ents.FindByClass("prop_door_rotating"))
	end
	destroying = table.Add(destroying, ents.FindByClass("weapon_physicscannon"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_crowbar"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_stunstick"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_357"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_pistol"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_smg1"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_ar2"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_crossbow"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_shotgun"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_rpg"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_slam"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_pumpshotgun"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_ak47"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_deagle"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_fiveseven"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_glock"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_m4"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_mac10"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_mp5"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_para"))
	destroying = table.Add(destroying, ents.FindByClass("weapon_tmp"))

	destroying = table.Add(destroying, ents.FindByClass("weapon_frag"))

	for _, ent in pairs(destroying) do
		ent:Remove()
	end

	local ammoreplace = ents.FindByClass("item_ammo_smg1")
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_357"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_357_large"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_pistol"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_pistol_large"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_buckshot"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_ar2"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_ar2_large"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_ar2_altfire"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_crossbow"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_smg1"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_ammo_smg1_large"))
	ammoreplace = table.Add(ammoreplace, ents.FindByClass("item_box_buckshot"))
	for _, ent in pairs(ammoreplace) do
		ent:Remove()
	end

	for _, ent in pairs(ents.FindByClass("prop_door_rotating")) do
		ent.AntiDoorSpam = 0
	end

	// These people decided to raid my servers and call me a faggot, ect, ect.
	// Well guys, don't play my gamemode if you don't like me that much.
	game.ConsoleCommand("banid 0 STEAM_0:0:9111454\n") // Beastmasta [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:0:13384253\n") // Dan waz ere [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:1:14145079\n") // LnK Chees502 [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:1:13932065\n") // CrAzY CrAcKeR[T&B] [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:1:2554470\n") // Mr. Fluffypants [Anti-Nox]
end

LastHumanSpawnPoint = Entity(1)
LastZombieSpawnPoint = Entity(1)
-- Returning nil on this fucking crashes the game.
function GM:PlayerSelectSpawn(pl)
	if pl:Team() == TEAM_UNDEAD then
		local Count = #self.UndeadSpawnPoints
		if Count == 0 then return pl end
		for i=0, 20 do
			local ChosenSpawnPoint = self.UndeadSpawnPoints[math.random(1, Count)]
			if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint:IsInWorld() and ChosenSpawnPoint ~= LastZombieSpawnPoint then
				local blocked = false
				for _, ent in pairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-48, -48, 0), ChosenSpawnPoint:GetPos() + Vector(48, 48, 60))) do
					if ent and ent:IsPlayer() then
						blocked = true
					end
				end
				if not blocked then
					LastZombieSpawnPoint = ChosenSpawnPoint
					return ChosenSpawnPoint
				end
			end
		end
		return LastZombieSpawnPoint
	else
		local Count = #self.HumanSpawnPoints
		if Count == 0 then return pl end
		for i=0, 20 do
			local ChosenSpawnPoint = self.HumanSpawnPoints[math.random(1, Count)]
			if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint:IsInWorld() and ChosenSpawnPoint ~= LastHumanSpawnPoint then
				local blocked = false
				for _, ent in pairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-48, -48, 0), ChosenSpawnPoint:GetPos() + Vector(48, 48, 60))) do
					if ent and ent:IsPlayer() then
						blocked = true
					end
				end
				if not blocked then
					LastHumanSpawnPoint = ChosenSpawnPoint
					return ChosenSpawnPoint
				end
			end
		end
		return LastHumanSpawnPoint
	end
	return pl
end

GM.AmmoTranslations = {}
GM.AmmoTranslations["weapon_physcannon"] = "pistol"
GM.AmmoTranslations["weapon_ar2"] = "ar2"
GM.AmmoTranslations["weapon_shotgun"] = "buckshot"
GM.AmmoTranslations["weapon_smg1"] = "smg1"
GM.AmmoTranslations["weapon_pistol"] = "pistol"
GM.AmmoTranslations["weapon_357"] = "357"
GM.AmmoTranslations["weapon_slam"] = "pistol"
GM.AmmoTranslations["weapon_crowbar"] = "pistol"
GM.AmmoTranslations["weapon_stunstick"] = "pistol"

function GM:SendInfliction(to)
	umsg.Start("SetInf", to)
		umsg.Float(INFLICTION)
	umsg.End()
end

function GM:SendInflictionInit(to)
	umsg.Start("SetInfInit", to)
		umsg.Float(INFLICTION)
	umsg.End()
end

NextAmmoDropOff = AMMO_REGENERATE_RATE
function GM:Think()
	if CurTime() >= ROUNDTIME then
	    self:EndRound(TEAM_HUMAN)
	elseif CurTime() >= NextAmmoDropOff then
	    NextAmmoDropOff = CurTime() + AMMO_REGENERATE_RATE
		INFLICTION = math.max(INFLICTION, CurTime() / ROUNDTIME)
		CAPPED_INFLICTION = INFLICTION
		self:SendInfliction()
	    local plays = player.GetAll()
	    if INFLICTION >= 0.75 then plays = table.Add(plays, player.GetAll()) end -- Double ammo on horde conditions
	    for _, pl in pairs(plays) do
	        if pl:Team() == TEAM_HUMAN then
	            local wep = pl:GetActiveWeapon()
	            if wep:IsValid() and wep:IsWeapon() then
					local typ = wep:GetPrimaryAmmoTypeString()
					if typ == "none" then
						if pl.HighestAmmoType == "none" then
							pl.HighestAmmoType = "pistol"
						end
						pl:GiveAmmo(AmmoRegeneration[pl.HighestAmmoType], pl.HighestAmmoType)
					else
						pl:GiveAmmo(AmmoRegeneration[typ], typ)
					end
	        	end
	        end
	    end
	end
end

function GM:EntityKeyValue(ent, key, value)
end

function GM:ShutDown()
end

DeadSteamIDs = {}
function GM:CalculateInfliction()
	if ENDROUND then return end
	local players = 0
	local zombies = 0
	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD then
			zombies = zombies + 1
		end
		players = players + 1
	end
	INFLICTION = math.max(math.Clamp(zombies / players, 0.01, 1), CAPPED_INFLICTION)
	CAPPED_INFLICTION = INFLICTION

	self:SendInfliction()
	if team.NumPlayers(TEAM_HUMAN) == 1 and team.NumPlayers(TEAM_UNDEAD) > 2 then
		self:LastHuman()
	elseif INFLICTION >= 1 then
		self:EndRound(TEAM_UNDEAD)
	end
end

function GM:OnNPCKilled(ent, attacker, inflictor)
	if NPCS_COUNT_AS_KILLS and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		attacker:AddFrags(1)
		self:CheckPlayerScore(attacker)
	end
end

function quicksort(q, cmp)
	if #q <= 1 then
		return q
	end
	if not cmp then
		cmp = function (a, b) return a < b end
	end
	local lower, higher, pivot = {}, {}, nil
	for i, v in ipairs(q) do
		if not pivot then
			pivot = v
		elseif cmp(v, pivot) then
			table.insert(lower, v)
		else
			table.insert(higher, v)
		end
	end
	local r = quicksort(lower, cmp)
	table.insert(r, pivot)
	table.Add(r, quicksort(higher, cmp))
	return r
end 

function GM:SendTopTimes(to)
	local PlayerSorted = {}

	for k, v in pairs(player.GetAll()) do
		if v.SurvivalTime then
			table.insert(PlayerSorted, v)
		end
	end

	if #PlayerSorted <= 0 then return end -- Don't bother sending it, the cleint gamemode won't display anything.
	table.sort(PlayerSorted,
	function(a, b)
		return a.SurvivalTime > b.SurvivalTime
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopTimes", to)
				umsg.Short(x)
				umsg.String(pl:Name()..": "..ToMinutesSeconds(pl.SurvivalTime))
			umsg.End()
		end
	end
end

function GM:SendTopZombies(to)
	local PlayerSorted = {}

	for k, v in pairs(player.GetAll()) do
		if v.BrainsEaten and v.BrainsEaten > 0 then
			table.insert(PlayerSorted, v)
		end
	end

	if #PlayerSorted <= 0 then return end -- Don't bother sending it, the cleint gamemode won't display anything.
	table.sort(PlayerSorted,
	function(a, b)
		if a.BrainsEaten == b.BrainsEaten then
			return a:Deaths() < b:Deaths() -- I needed some way to rank it.
		end
		return a.BrainsEaten > b.BrainsEaten
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopZombies", to)
				umsg.Short(x)
				umsg.String(pl:Name()..": "..pl.BrainsEaten)
			umsg.End()
		end
	end
end

function GM:SendTopHumanDamages(to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.DamageDealt[TEAM_HUMAN] > 0 then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_HUMAN] == b.DamageDealt[TEAM_HUMAN] then
			return a:UniqueID() > b:UniqueID()
		end
		return a.DamageDealt[TEAM_HUMAN] > b.DamageDealt[TEAM_HUMAN]
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopHumanDamages", to)
				umsg.Short(x)
				umsg.String(pl:Name()..": "..math.ceil(pl.DamageDealt[TEAM_HUMAN]))
			umsg.End()
		end
	end
end

function GM:SendTopZombieDamages(to)
	local PlayerSorted = {}

	for _, pl in pairs(player.GetAll()) do
		if pl.DamageDealt[TEAM_UNDEAD] > 0 then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_UNDEAD] == b.DamageDealt[TEAM_UNDEAD] then
			return a:UniqueID() > b:UniqueID()
		end
		return a.DamageDealt[TEAM_UNDEAD] > b.DamageDealt[TEAM_UNDEAD]
	end
	)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopZombieDamages", to)
				umsg.Short(x)
				umsg.String(pl:Name()..": "..math.ceil(pl.DamageDealt[TEAM_UNDEAD]))
			umsg.End()
		end
	end
end

function GM:EndRound(winner)
	if ENDROUND then return end
	ROUNDWINNER = winner
	if winner == TEAM_HUMAN then
		for _, pl in pairs(player.GetAll()) do
			if pl.SpawnedTime and pl:Team() == TEAM_HUMAN then
				pl.SurvivalTime = CurTime() - pl.SpawnedTime
			end
		end
	end
	local nextmap = game.GetMapNext()
	timer.Simple(INTERMISSION_TIME, game.LoadNextMap)
	//timer.Simple(INTERMISSION_TIME*0.55, gmod.BroadcastLua, "OpenVoteMenu()")
	ENDROUND = true
	for _, pl in pairs(player.GetAll()) do
		pl:Lock()
		pl.NextSpawnTime = 99999
	end
	hook.Add("PlayerInitialSpawn", "LateJoin", function(pl)
		pl:SendLua("Intermission('"..game.GetMapNext().."', "..ROUNDWINNER..")")
		GAMEMODE:SendTopTimes(pl)
		GAMEMODE:SendTopZombies(pl)
		GAMEMODE:SendTopHumanDamages(pl)
		GAMEMODE:SendTopZombieDamages(pl)
	end)
	hook.Add("PlayerSpawn", "LateJoin2", function(pl)
		pl:Lock()
	end)
	gmod.BroadcastLua("Intermission('"..nextmap.."', "..winner..")")
	timer.Simple(1, function()
	GAMEMODE:SendTopTimes()
	GAMEMODE:SendTopZombies()
	GAMEMODE:SendTopHumanDamages()
	GAMEMODE:SendTopZombieDamages()
	end)
end

function GM:PlayerInitialSpawn(pl)
	pl:SetZombieClass(1)
	self:SendInflictionInit(pl)
	pl.Gibbed = false
	pl.BrainsEaten = 0
	pl.ZombiesKilled = 0
	pl.NextPainSound = 0
	pl.HighestAmmoType = "pistol"
	pl.DamageDealt = {}
	pl.DamageDealt[TEAM_UNDEAD] = 0
	pl.DamageDealt[TEAM_HUMAN] = 0

	if DeadSteamIDs[pl:SteamID()] then
		pl:SetTeam(TEAM_UNDEAD)
	elseif team.NumPlayers(TEAM_UNDEAD) < 1 and team.NumPlayers(TEAM_HUMAN) > 2 then
		pl:SetTeam(TEAM_UNDEAD)
		DeadSteamIDs[pl:SteamID()] = true
	elseif INFLICTION >= 0.5 or (CurTime() > ROUNDTIME*0.5 and HUMAN_DEADLINE) or LASTHUMAN then
		pl:SetTeam(TEAM_UNDEAD)
		DeadSteamIDs[pl:SteamID()] = true
	else
		pl:SetTeam(TEAM_HUMAN)
		pl.SpawnedTime = CurTime()
	end
	self:CalculateInfliction()

	-- We're going to play a little trick on these dumbshits.
	-- OUTDATED BY SCRIPT ENFORCER
	/*
	pl:SendLua([[PLAYERmeta=FindMetaTable("Player")]])
	pl:SendLua([[ENTITYmeta=FindMetaTable("Entity")]])
	local timername = pl:UniqueID().."AntiHack"
	timer.Create(timername, math.random(14, 22), 3, AntiHack, pl, timername)
	*/
end

/*
function AntiHack(pl, timername)
	if pl:IsValid() and pl:IsPlayer() then
		pl:SendLua([[function ENTITYmeta:GetAttachment(i) LocalPlayer():ConCommand("~Z_~_ban_me\n") end]])
		pl:SendLua([[function PLAYERmeta:SetEyeAngles() LocalPlayer():ConCommand("~Z_~_ban_me\n") end]])
	else
		timer.Destroy(timername)
	end
end
*/

function GM:CheckPlayerScore(pl)
	local score = pl:Frags()
	if Rewards[score] then
		local reward = Rewards[score][math.random(1, #Rewards[score])]
		if string.sub(reward, 1, 1) == "_" then
			PowerupFunctions[reward](pl)
			pl:SendLua("rW()")
		else
			pl:Give(reward)
			local wep = pl:GetWeapon(reward)
			if wep:IsValid() then
				pl.HighestAmmoType = wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType
			end
		end
	end
end

--[[PLAYER_IDLE
PLAYER_WALK
PLAYER_JUMP
PLAYER_SUPERJUMP
PLAYER_DIE
PLAYER_ATTACK1
PLAYER_IN_VEHICLE
PLAYER_RELOAD
PLAYER_START_AIMING
PLAYER_LEAVE_AIMING
]]

-- Poison Zombie
local PoisonZombieAnimTranslateTable = {}
PoisonZombieAnimTranslateTable[PLAYER_IDLE] = ACT_IDLE
PoisonZombieAnimTranslateTable[PLAYER_WALK] = ACT_WALK
PoisonZombieAnimTranslateTable[PLAYER_JUMP] = ACT_WALK
PoisonZombieAnimTranslateTable[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
PoisonZombieAnimTranslateTable[PLAYER_SUPERJUMP] = ACT_RANGE_ATTACK2

function SetPlayerPoisonZombieAnimation(pl, anim)
	local act = ACT_IDLE
	local Speed = pl:GetVelocity():Length()

	if PoisonZombieAnimTranslateTable[anim] ~= nil then
		act = PoisonZombieAnimTranslateTable[anim]
	else
		if Speed > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_IDLE_ON_FIRE then
		if Speed > 0 then
			act = ACT_WALK_ON_FIRE
		end
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		pl:SetPlaybackRate(2)
		pl:RestartGesture(act)
		return true
	end

	local seq = pl:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 3
	end

	if seq == 3 then
		pl:SetPlaybackRate(1.5)
	else
		pl:SetPlaybackRate(1.0)
	end

	if pl:GetSequence() == seq then return true end
	pl:ResetSequence(seq)
	pl:SetCycle(0)
	return true
end

-- Fast Zombie
local FastZombieAnimTranslateTable = {}
FastZombieAnimTranslateTable[PLAYER_IDLE] = ACT_IDLE
FastZombieAnimTranslateTable[PLAYER_WALK] = ACT_RUN
FastZombieAnimTranslateTable[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
FastZombieAnimTranslateTable[PLAYER_SUPERJUMP] = ACT_CLIMB_UP

function SetPlayerFastZombieAnimation(pl, anim)
	local act = ACT_IDLE
	local Speed = pl:GetVelocity():Length()
	local OnGround = pl:OnGround()

	if FastZombieAnimTranslateTable[anim] ~= nil then
		act = FastZombieAnimTranslateTable[anim]
	else
		if Speed > 0 then
			act = ACT_RUN
		end
	end

	if act == ACT_MELEE_ATTACK1 or act == ACT_CLIMB_UP then
		pl:RestartGesture(act)
		return true
	end

	local seq = pl:SelectWeightedSequence(act)

	if not OnGround and act ~= ACT_CLIMB_UP then
	    seq = 3
	end

	if pl:GetSequence() == seq then return true end
	pl:ResetSequence(seq)
	pl:SetPlaybackRate(1.0)
	pl:SetCycle(0)
	return true
end

-- Headcrab
local HeadcrabAnimTranslateTable = {}
HeadcrabAnimTranslateTable[PLAYER_IDLE] = ACT_IDLE
HeadcrabAnimTranslateTable[PLAYER_WALK] = ACT_RUN
HeadcrabAnimTranslateTable[PLAYER_ATTACK1] = ACT_RANGE_ATTACK1

function SetPlayerHeadcrabAnimation(pl, anim)
	local act = ACT_IDLE
	local Speed = pl:GetVelocity():Length()
	local OnGround = pl:OnGround()

	if HeadcrabAnimTranslateTable[anim] then
		act = HeadcrabAnimTranslateTable[anim]
	else
		if Speed > 0 then
			act = ACT_RUN
		end
	end

	if act == ACT_RANGE_ATTACK1 then
		pl:RestartGesture(act)
		return true
	end

	local seq = pl:SelectWeightedSequence(act)

	if not OnGround then
	    seq = "Drown"
	end

	if pl:GetSequence() == seq then return true end
	pl:ResetSequence(seq)
	if seq == 5 then
		pl:SetPlaybackRate(1.0)
	else
		pl:SetPlaybackRate(0.3)
	end
	pl:SetCycle(0)
	return true
end

-- Classic Zombie
local ZombieAnimTranslateTable = {}
ZombieAnimTranslateTable[PLAYER_IDLE] = ACT_IDLE
ZombieAnimTranslateTable[PLAYER_WALK] = ACT_WALK
ZombieAnimTranslateTable[PLAYER_JUMP] = ACT_WALK
ZombieAnimTranslateTable[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1
ZombieAnimTranslateTable[PLAYER_SUPERJUMP] = ACT_IDLE_ON_FIRE

function SetPlayerZombieAnimation(pl, anim)
	local act = ACT_IDLE
	local Speed = pl:GetVelocity():Length()

	if ZombieAnimTranslateTable[anim] ~= nil then
		act = ZombieAnimTranslateTable[anim]
	else
		if Speed > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_IDLE_ON_FIRE then
		if Speed > 0 then
			act = ACT_WALK_ON_FIRE
		end
	end

	if act == ACT_MELEE_ATTACK1 or anim == PLAYER_SUPERJUMP then
		pl:SetPlaybackRate(2)
		pl:RestartGesture(act)
		return true
	end

	local seq = pl:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 2
	end

	if seq == 2 then
		pl:SetPlaybackRate(1.5)
	else
		pl:SetPlaybackRate(1.0)
	end
	if pl:GetSequence() == seq then return true end
	pl:ResetSequence(seq)
	pl:SetCycle(0)
	return true
end

-- Zombie Torso
local ZombieTorsoAnimTranslateTable = {}
ZombieTorsoAnimTranslateTable[PLAYER_IDLE] = ACT_IDLE
ZombieTorsoAnimTranslateTable[PLAYER_WALK] = ACT_WALK
ZombieTorsoAnimTranslateTable[PLAYER_JUMP] = ACT_WALK
ZombieTorsoAnimTranslateTable[PLAYER_ATTACK1] = ACT_MELEE_ATTACK1

function SetPlayerZombieTorsoAnimation(pl, anim)
	local act = ACT_IDLE
	local Speed = pl:GetVelocity():Length()

	if ZombieTorsoAnimTranslateTable[anim] ~= nil then
		act = ZombieTorsoAnimTranslateTable[anim]
	else
		if Speed > 0 then
			act = ACT_WALK
		end
	end

	if act == ACT_IDLE_ON_FIRE then
		if Speed > 0 then
			act = ACT_WALK_ON_FIRE
		end
	end

	if act == ACT_MELEE_ATTACK1 then
		pl:SetPlaybackRate(2)
		pl:RestartGesture(act)
		return true
	end

	local seq = pl:SelectWeightedSequence(act)
	if act == ACT_WALK then
		seq = 2
	end

	if seq == 2 then
		pl:SetPlaybackRate(1.5)
	else
		pl:SetPlaybackRate(1.0)
	end
	if pl:GetSequence() == seq then return true end
	pl:ResetSequence(seq)
	pl:SetCycle(0)
	return true
end

local AnimTranslateTable = {}
AnimTranslateTable[PLAYER_RELOAD] = ACT_HL2MP_GESTURE_RELOAD
AnimTranslateTable[PLAYER_JUMP] = ACT_HL2MP_JUMP
AnimTranslateTable[PLAYER_ATTACK1] = ACT_HL2MP_GESTURE_RANGE_ATTACK

SpecialAnims = {}
SpecialAnims[1] = SetPlayerZombieAnimation
SpecialAnims[2] = SetPlayerFastZombieAnimation
SpecialAnims[3] = SetPlayerPoisonZombieAnimation
SpecialAnims[4] = SetPlayerPoisonZombieAnimation
SpecialAnims[5] = SetPlayerHeadcrabAnimation
SpecialAnims[6] = SetPlayerZombieTorsoAnimation

function GM:SetPlayerAnimation(pl, anim)
	if pl:Team() == TEAM_UNDEAD then
		SpecialAnims[pl.Class](pl, anim)
		return
	end

	local act = ACT_HL2MP_IDLE
	local Speed = pl:GetVelocity():Length()
	local OnGround = pl:OnGround()

	if AnimTranslateTable[anim] ~= nil then
		act = AnimTranslateTable[anim]
	else
		if OnGround and pl:Crouching() then
			act = ACT_HL2MP_IDLE_CROUCH
			if Speed > 0 then
				act = ACT_HL2MP_WALK_CROUCH
			end
		elseif Speed > 0 then
			act = ACT_HL2MP_RUN
		end
	end

	if act == ACT_HL2MP_GESTURE_RANGE_ATTACK or act == ACT_HL2MP_GESTURE_RELOAD then
		pl:RestartGesture(pl:Weapon_TranslateActivity(act))
		if act == ACT_HL2MP_GESTURE_RANGE_ATTACK then
			pl:Weapon_SetActivity(pl:Weapon_TranslateActivity(ACT_RANGE_ATTACK1), 0)
		end
		return
	end

	if not OnGround then
		act = ACT_HL2MP_JUMP
	end

	local seq = pl:SelectWeightedSequence(pl:Weapon_TranslateActivity(act))

	-- Let's assume that no admins spawn any vehicles and that we always have a weapon.

	if pl:GetSequence() == seq then return end
	pl:SetPlaybackRate(1.0)
	pl:ResetSequence(seq)
	pl:SetCycle(0)
end

function GM:PlayerNoClip(pl, on)
	return pl:IsAdmin() and ALLOW_ADMIN_NOCLIP
end

function GM:OnPhysgunFreeze(weapon, phys, ent, ply)
end

function GM:OnPhysgunReload(weapon, ply)
end

function GM:PlayerDisconnected(player)
	timer.Simple(2, self.CalculateInfliction, GAMEMODE)
end

function GM:PlayerSay(player, text, teamonly)
	return text
end

function GM:PlayerDeathThink(pl)
	if CurTime() > pl.NextSpawnTime then
		if pl:Team() == TEAM_UNDEAD then
			if pl:KeyDown(IN_ATTACK) then
				pl:Spawn()
			end
		else
			pl:Spawn()
		end
	end
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if attacker.SendLua then
		if attacker:Team() == pl:Team() then
			return attacker == pl
		end
	end
	return true
end

/*
function GM:PlayerHurt(pl, attacker)

end
*/

/*
function GM:EntityTakeDamage(ent, inflictor, attacker, amount)
	if ent:IsPlayer() then
		ent:PlayPainSound()
		if attacker:IsValid() and attacker:IsPlayer() and attacker:Team() ~= ent:Team() then
			ent.LastAttacker = attacker
			attacker.DamageDealt[attacker:Team()] = attacker.DamageDealt[attacker:Team()] + amount
		end
	end
end
*/

function GM:PlayerUse(pl, entity)
	if not entity then return end
	if not entity:IsValid() then return end
	if pl:Team() == TEAM_UNDEAD then
		if entity:GetName() == "gib" then
			entity:Remove()
		end
	end
	if entity:GetClass() == "prop_door_rotating" then
		if CurTime() > entity.AntiDoorSpam then
			entity.AntiDoorSpam = CurTime() + 0.85
			return true
		else
			return false
		end
	end
	return true
end

function SecondWind(pl)
	if pl and pl:IsValid() and pl:IsPlayer() and not pl.DeathClass then
		if pl.Gibbed or pl:Alive() or pl:Team() ~= TEAM_UNDEAD then return end
		local pos = pl:GetPos()
		local eyeangles = pl:GetAngles()
		pl:Spawn()
		DeSpawnProtection(pl)
		pl:SetPos(pos)
		pl:SetEyeAngles(eyeangles)
		pl:SetHealth(pl:Health() * 0.2)
		pl:EmitSound("npc/zombie/zombie_voice_idle"..math.random( 1, 14 )..".wav", 100, 85)
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
end

function GM:PlayerDeathSound()
	return true	// Handled below.
end

// TODO: Make this code shorter.
function GM:DoPlayerDeath(pl, attacker, dmginfo)
	local headshot = dmginfo:IsBulletDamage() and math.abs(dmginfo:GetDamagePosition().z - pl:GetAttachment(1).Pos.z) < 13
	local revive = false
	local inflictor = NULL
	local suicide = false

	if attacker and attacker:IsValid() then
		if (attacker == pl or attacker:IsWorld()) and pl.LastAttacker and pl.LastAttacker:IsValid() and pl.LastAttacker:Team() ~= pl:Team() then
			attacker = pl.LastAttacker
			inflictor = attacker:GetActiveWeapon()
			suicide = true
			pl.LastAttacker = nil
		elseif attacker:IsPlayer() then
			inflictor = attacker:GetActiveWeapon()
		elseif attacker:GetOwner():IsValid() then -- For NPC's with owners
			local owner = attacker:GetOwner()
			inflictor = attacker
			attacker = owner
		end
	end
	if inflictor == NULL then inflictor = attacker end

	if pl.Headcrabz then
		for _, headcrab in pairs(pl.Headcrabz) do
			if headcrab:IsValid() and headcrab:IsNPC() then
				headcrab:Fire("sethealth", "0", 5)
			end
		end
	end

	pl.NextSpawnTime = CurTime() + 4
	pl:AddDeaths(1)
	if pl.Class == 4 and pl:Team() == TEAM_UNDEAD and attacker ~= pl and not suicide then
		local effectdata = EffectData()
			effectdata:SetOrigin(pl:GetPos())
		util.Effect("chemzombieexplode", effectdata)
		pl:Gib(dmginfo)
		pl.Gibbed = true
		timer.Simple(0.05, util.BlastDamage, pl, pl, pl:GetPos() + Vector(0,0,16), 150, 40)
	elseif pl:Health() < -24 or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage() then
		pl:Gib(dmginfo)
		pl.Gibbed = true
	else
		pl:CreateRagdoll()
	end
	if pl:Team() == TEAM_UNDEAD then
		if attacker:IsValid() and attacker:IsPlayer() and attacker ~= pl then
			if ZombieClasses[pl.Class].Revives then
				if not pl.Gibbed and not headshot and math.random(1, 4) ~= 1 then
					if pl.Class == 1 then
						if math.random(1, 3) == 3 then
							timer.Simple(0, SecondWind, pl)
							revive = true
							pl.Class = 6
							pl:LegsGib()
						else
							timer.Simple(2, SecondWind, pl)
							revive = true
						end
					else
						timer.Simple(2, SecondWind, pl)
						revive = true
					end
				else
					attacker:AddFrags(1)
					attacker.ZombiesKilled = attacker.ZombiesKilled + 1
					pl:PlayZombieDeathSound()
					self:CheckPlayerScore(attacker)
				end
			else
				attacker:AddFrags(1)
				attacker.ZombiesKilled = attacker.ZombiesKilled + 1
				pl:PlayZombieDeathSound()
				self:CheckPlayerScore(attacker)
			end
		else
			pl:PlayZombieDeathSound()
		end
	else
		pl:PlayDeathSound()
		if attacker:IsPlayer() and attacker ~= pl then
			attacker:AddFrags(1)
			attacker.BrainsEaten = attacker.BrainsEaten + 1
			if REDEEM and AUTOREDEEM then
				if attacker:Frags() >= REDEEM_KILLS then
					attacker:Redeem()
				end
			end
			if not pl.Gibbed then
				timer.Simple(2.5, SecondWind, pl)
			end
		end
		if #player.GetAll() > 1 then
			pl:SetTeam(TEAM_UNDEAD)
			DeadSteamIDs[pl:SteamID()] = true
		end
		pl:SendLua("Died()")
		pl:SetFrags(0)
		if pl.SpawnedTime then
			local survtime = CurTime() - pl.SpawnedTime
			if pl.SurvivalTime then
				if survtime > pl.SurvivalTime then
					pl.SurvivalTime = survtime
				end
			else
				pl.SurvivalTime = CurTime() - pl.SpawnedTime
			end
		end
		pl.SpawnedTime = nil
		self:CalculateInfliction()
	end

	if revive then return end
	if attacker == pl then
		umsg.Start("PlayerKilledSelf")
			umsg.Entity(pl)
		umsg.End()
		return
	end

	if attacker:IsPlayer() then
		local getclass = inflictor:GetClass()
		if headshot then
			pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
			local effectdata = EffectData()
				effectdata:SetOrigin(pl:GetAttachment(1).Pos)
				effectdata:SetNormal(dmginfo:GetDamageForce():Normalize())
				effectdata:SetMagnitude(dmginfo:GetDamageForce():Length() * 3)
			util.Effect("headshot", effectdata)
		end
		umsg.Start("PlayerKilledByPlayer")
			umsg.Entity(pl)
			umsg.String(getclass)
			umsg.Entity(attacker)
			umsg.Bool(headshot)
		umsg.End()
		return
	end

	umsg.Start("PlayerKilled")
		umsg.Entity(pl)
		umsg.String(inflictor:GetClass())
		umsg.String(attacker:GetClass())
	umsg.End()
end

function GM:PlayerCanPickupWeapon(ply, entity)
	if ply:Team() == TEAM_UNDEAD then return entity:GetClass() == ZombieClasses[ply.Class].SWEP end
	return true
end

function SpawnProtection(pl, tim)
	GAMEMODE:SetPlayerSpeed(pl, ZombieClasses[pl:GetZombieClass()].Speed * 1.5)
	pl:SetMaterial("models/shiny")
	pl:GodEnable()
	timer.Create(pl:UserID().."SpawnProtection", tim, 1, DeSpawnProtection, pl)
end

function DeSpawnProtection(pl)
	if pl:IsValid() and pl:IsPlayer() then
		GAMEMODE:SetPlayerSpeed(pl, ZombieClasses[pl.Class].Speed)
		pl:SetMaterial("")
		pl:GodDisable()
	end
end

function GM:PlayerSpawn(pl)
	pl:UnSpectate()
	pl.Gibbed = false
	timer.Destroy(pl:UserID().."SpawnProtection")
	if pl:Team() == TEAM_UNDEAD then
		if pl.DeathClass then
			pl:SetZombieClass(pl.DeathClass)
			pl.DeathClass = nil
		end
		local class = pl:GetZombieClass()
		pl:SetModel(ZombieClasses[class].Model)
		if team.NumPlayers(TEAM_UNDEAD) <= 1 then
			pl:SetHealth(ZombieClasses[class].Health * 2)
		else
			pl:SetHealth(ZombieClasses[class].Health)
		end
		local swep = ZombieClasses[class].SWEP
		pl:Give(swep)
		self:SetPlayerSpeed(pl, ZombieClasses[class].Speed)
		pl:SetNoTarget(true)
		pl:SendLua("ZomC()")
		pl:SetMaxHealth(1) -- To prevent picking up health packs
		SpawnProtection(pl, 5 - INFLICTION*5) -- Less infliction, more spawn protection.
		pl.Female = false
	else
		local modelname = player_manager.TranslatePlayerModel(pl:GetInfo("cl_playermodel"))
		if RestrictedModels[modelname] then
			pl:SetModel(Model("models/player/alyx.mdl"))
		else
			pl:SetModel(Model(modelname))
		end
		pl:SetFemale()
		pl:Give("weapon_zs_battleaxe")
		pl:Give("weapon_zs_swissarmyknife")
		self:SetPlayerSpeed(pl, 170)
		pl:SetNoTarget(false)
		pl:SendLua("HumC()")
		pl:SetMaxHealth(100)
	end
	pl.LastHealth = pl:Health()
end

function GM:WeaponEquip(weapon)
end

function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
    if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(HEAD_NPC_SCALE)
	end
	return dmginfo
end

function GM:ScalePlayerDamage(npc, hitgroup, dmginfo)
    if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(2.5)
	end
	return dmginfo
end

function ThrowHeadcrab(owner, wep)
	if not owner:IsValid() then return end
	if not owner:IsPlayer() then return end
	if not wep.Weapon then return end
	if owner:Alive() and owner:Team() == TEAM_UNDEAD and owner.Class == 3 then
		GAMEMODE:SetPlayerSpeed(owner, ZombieClasses[3].Speed)
		wep.Headcrabs = wep.Headcrabs - 1
		local eyeangles = owner:EyeAngles()
		local vel = eyeangles:Forward():Normalize()
		eyeangles.pitch = 0
		local ent = ents.Create("npc_headcrab_black")
		if ent:IsValid() then
			ent:SetPos(owner:GetShootPos())
			ent:SetAngles(eyeangles)
			ent:SetOwner(owner)
			ent:SetKeyValue("spawnflags", "4")
			ent:Spawn()
			if not ent:IsInWorld() then
				wep.Headcrabs = wep.Headcrabs + 1
				ent:Remove()
				return
			end
			for _, pl in pairs(player.GetAll()) do
				if pl:Team() == TEAM_UNDEAD then
					ent:AddEntityRelationship(pl, D_LI, 99)
				else
					ent:AddEntityRelationship(pl, D_HT, 99)
				end
			end
			vel = vel * 450
			vel.z = math.max(100, vel.z)
			ent:SetVelocity(vel)
			ent:EmitSound("npc/headcrab_poison/ph_jump"..math.random(1,3)..".wav")
			owner.Headcrabz = owner.Headcrabz or {}
			table.insert(owner.Headcrabz, ent)
		end
	end
end

local function SelectZombieClass(sender, command, arguments)
	if arguments[1] == nil then return end
	if sender:Team() ~= TEAM_UNDEAD or not sender:Alive() then return end
	arguments = table.concat(arguments, " ")
	for i=1, #ZombieClasses do
		if string.lower(ZombieClasses[i].Name) == string.lower(arguments) then
			if ZombieClasses[i].Hidden then
				sender:PrintMessage(3, "STOP SHOUTING!")
			elseif ZombieClasses[i].Threshold > INFLICTION then
				sender:PrintMessage(3, "There are too many living to use that class.")
			elseif sender.Class == i then
				sender:PrintMessage(3, "You are already a "..ZombieClasses[i].Name.."!")
			else
				sender:PrintMessage(3, "You will respawn as a "..ZombieClasses[i].Name..".")
				sender.DeathClass = i
			end
		    return
		end
	end
end
concommand.Add("zs_class", SelectZombieClass)

local function KickMe(sender, command, arguments)
	game.ConsoleCommand("kickid "..sender:SteamID().." Aimbot / using walk.\n")
end
concommand.Add("kick_me", KickMe)

local function BanMe(sender, command, arguments)
	timer.Destroy(sender:UniqueID().."AntiHack")
	game.ConsoleCommand("banid 2880 "..sender:SteamID().."\n")
	game.ConsoleCommand("kickid "..sender:SteamID().." 48 hour ban for client hacks.\n")
	game.ConsoleCommand("writeid\n")
end
concommand.Add("~Z_~_ban_me", BanMe)

local function WateryDeath(sender, command, arguments)
	sender:Kill()
	sender:EmitSound("player/pl_drown"..math.random(1, 3)..".wav")
end
concommand.Add("~Z_~_water_death", WateryDeath)

local function WateryDeath(sender, command, arguments)
	sender:TakeDamage(200, NULL)
	for _, pl in pairs(player.GetAll()) do
		pl:PrintMessage(3, sender:Name().."'s spine crumbled in to dust.")
	end
end
concommand.Add("~Z_~_cramped_death", WateryDeath)
