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
AddCSLuaFile("cl_beats.lua")
AddCSLuaFile("cl_dermaskin.lua")

AddCSLuaFile("obj_player_extend.lua")
AddCSLuaFile("obj_weapon_extend.lua")

AddCSLuaFile("zs_options.lua")

AddCSLuaFile("vgui/scoreboard.lua")
AddCSLuaFile("vgui/poptions.lua")
AddCSLuaFile("vgui/phelp.lua")
AddCSLuaFile("vgui/pclasses.lua")

AddCSLuaFile("cl_splitmessage.lua")

include("shared.lua")
include("powerups.lua")
include("animations.lua")

GM.PlayerSpawnTime = {}

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

LASTHUMAN = false
CAPPED_INFLICTION = 0
HEAD_NPC_SCALE = math.Clamp(3 - DIFFICULTY, 1.5, 4)
LastHumanSpawnPoint = NULL
LastZombieSpawnPoint = NULL
DeadSteamIDs = {}

if file.Exists("../gamemodes/zombiesurvival/gamemode/maps/"..game.GetMap()..".lua") then
	include("maps/"..game.GetMap()..".lua")
end

gmod.BroadcastLua = gmod.BroadcastLua or function(lua)
	for _, pl in pairs(player.GetAll()) do
		pl:SendLua(lua)
	end
end

function GM:PlayerLoadout(pl)
end

function GM:Initialize()
	resource.AddFile("resource/fonts/anthem.ttf")
	for _, filename in pairs(file.Find("../materials/zombiesurvival/*.*")) do
		resource.AddFile("materials/zombiesurvival/"..filename)
	end
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
	resource.AddFile("sound/zbeat8.wav")
	resource.AddFile("sound/zbeat7.wav")
	resource.AddFile("sound/zbeat6.wav")
	resource.AddFile("sound/zbeat5.wav")
	resource.AddFile("sound/zbeat4.wav")
	resource.AddFile("sound/zbeat3.wav")
	resource.AddFile("sound/zbeat2.wav")
	resource.AddFile("sound/zbeat1.wav")
	resource.AddFile("materials/zombohead.vmt")
	resource.AddFile("materials/zombohead.vtf")
	resource.AddFile("materials/humanhead.vmt")
	resource.AddFile("materials/humanhead.vtf")
	resource.AddFile("materials/killicon/zs_zombie.vtf")
	resource.AddFile("materials/killicon/zs_zombie.vmt")
	resource.AddFile("materials/killicon/redeem.vtf")
	resource.AddFile("materials/killicon/redeem.vmt")
	resource.AddFile("models/weapons/v_zombiearms.mdl")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet.vmt")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet.vtf")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet_normal.vtf")
	resource.AddFile("models/weapons/v_fza.mdl")
	resource.AddFile("models/weapons/v_pza.mdl")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet.vmt")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet.vtf")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet_normal.vtf")
	resource.AddFile("sound/"..LASTHUMANSOUND)
	resource.AddFile("sound/"..ALLLOSESOUND)
	resource.AddFile("sound/"..HUMANWINSOUND)
	resource.AddFile("sound/"..DEATHSOUND)
	resource.AddFile("sound/unlife1.mp3")
	//resource.AddFile("sound/unlife2.mp3")
	//resource.AddFile("sound/unlife3.mp3")

	for _, filename in pairs(file.Find("../materials/models/weapons/v_pza/*.*")) do
		resource.AddFile("materials/models/weapons/v_pza/"..string.lower(filename))
	end

	RunConsoleCommand("mp_mm_max_spectators", "0")
	RunConsoleCommand("mp_allowspectators", "0")
end

function GM:ShowHelp(pl)
	pl:SendLua("MakepHelp()")
end
concommand.Add("gm_help", function(sender, command, arguments) GAMEMODE:ShowHelp(sender) end)

function GM:ShowTeam(pl)
	if REDEEM and not AUTOREDEEM and pl:Team() == TEAM_UNDEAD and pl:Frags() >= REDEEM_KILLS then
		pl:Redeem()
	end
end

function GM:ShowSpare1(pl)
	if pl:Team() == TEAM_UNDEAD then
		pl:SendLua("MakepClasses()")
	end
end

function GM:ShowSpare2(pl)
	pl:SendLua("MakepOptions()")
end

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
		ent.AntiDoorSpam = -10
	end

	// Server raiders.
	game.ConsoleCommand("banid 0 STEAM_0:0:9111454\n") // Beastmasta [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:0:13384253\n") // Dan waz ere [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:1:14145079\n") // LnK Chees502 [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:1:13932065\n") // CrAzY CrAcKeR[T&B] [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:1:2554470\n") // Mr. Fluffypants [Anti-Nox]
	game.ConsoleCommand("banid 0 STEAM_0:0:14096469\n") // [GU]Blackie Chan
	game.ConsoleCommand("banid 0 STEAM_0:1:5142073\n") // [GU]legohalflife2man
	game.ConsoleCommand("banid 0 STEAM_0:1:4976333\n") // Rick Darkaliono
	game.ConsoleCommand("banid 0 STEAM_0:1:570642\n") // GRE3N
	game.ConsoleCommand("addip 0 98.197.239.168\n")

	// Site raiders.
	game.ConsoleCommand("addip 0 70.68.206.139\n")
	game.ConsoleCommand("addip 0 198.53.9.21\n")
	game.ConsoleCommand("addip 0 212.112.241.44\n")

	// Some idiot who thinks that I'm not JetBoom and that there's no blacklist.
	game.ConsoleCommand("banid 0 STEAM_0:0:14691358\n")

	// Giving out exploit on how to bypass ScriptEnforcer.
	game.ConsoleCommand("banid 0 STEAM_0:1:4556804\n") // Azu

	// Never unban these.
	game.ConsoleCommand("banid 0 STEAM_0:0:16663555\n")
	game.ConsoleCommand("banid 0 STEAM_0:1:2468193\n")
	game.ConsoleCommand("banid 0 STEAM_0:1:14027318\n")
	game.ConsoleCommand("banid 0 STEAM_0:1:14154113\n")
	game.ConsoleCommand("banid 0 STEAM_0:1:8473297\n")
	game.ConsoleCommand("banid 0 STEAM_0:0:16917619\n")

	self.MapEditorEntities = {}
	file.CreateDir("zsmaps")
	if file.Exists("zsmaps/"..game.GetMap()..".txt") then
		for _, stuff in pairs(string.Explode(",", file.Read("zsmaps/"..game.GetMap()..".txt"))) do
			local expstuff = string.Explode(" ", stuff)
			local ent = ents.Create(expstuff[1])
			if ent:IsValid() then
				ent:SetPos(Vector(tonumber(expstuff[2]), tonumber(expstuff[3]), tonumber(expstuff[4])))
				for i=5, #expstuff do
					local kv = string.Explode("§", expstuff[i])
					ent:SetKeyValue(kv[1], kv[2])
				end
				ent:Spawn()
				table.insert(self.MapEditorEntities, ent)
			end
		end
	end
end

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
	local tim = CurTime()

	if ROUNDTIME < tim then
		self:EndRound(TEAM_HUMAN)
	elseif NextAmmoDropOff < tim then
		if SURVIVALMODE then
			NextAmmoDropOff = 99999
			return
		end

		NextAmmoDropOff = CurTime() + AMMO_REGENERATE_RATE
		INFLICTION = math.max(INFLICTION, CurTime() / ROUNDTIME)
		CAPPED_INFLICTION = INFLICTION

		self:SendInfliction()

		local plays = player.GetAll()
		if 0.75 <= INFLICTION then plays = table.Add(plays, player.GetAll()) end -- Double ammo on horde conditions

		for _, pl in pairs(plays) do
			if pl:Team() == TEAM_HUMAN then
				local wep = pl:GetActiveWeapon()
				if wep:IsValid() and wep:IsWeapon() then
					local typ = wep:GetPrimaryAmmoTypeString()
					if typ == "none" then
						if pl.HighestAmmoType == "none" then
							pl.HighestAmmoType = "pistol"
						end
						pl:GiveAmmo(self.AmmoRegeneration[pl.HighestAmmoType], pl.HighestAmmoType, true)
					else
						pl:GiveAmmo(self.AmmoRegeneration[typ], typ, true)
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
	INFLICTION = math.max(math.Clamp(zombies / players, 0.001, 1), CAPPED_INFLICTION)
	CAPPED_INFLICTION = INFLICTION

	if team.NumPlayers(TEAM_HUMAN) == 1 and team.NumPlayers(TEAM_UNDEAD) > 2 then
		self:LastHuman()
	elseif INFLICTION >= 1 then
		self:EndRound(TEAM_UNDEAD)
	elseif INFLICTION >= 0.75 then
		UNLIFE = true
	elseif INFLICTION >= 0.5 then
		HALFLIFE = true
	end

	self:SendInfliction()
end

function GM:OnNPCKilled(ent, attacker, inflictor)
	if NPCS_COUNT_AS_KILLS and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		attacker:AddFrags(1)
		self:CheckPlayerScore(attacker)
	end
end

function GM:LastHuman()
	if LASTHUMAN then return end

	gmod.BroadcastLua("GAMEMODE:LastHuman()")
	LASTHUMAN = true
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
	end)

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
			return a:Deaths() < b:Deaths()
		end
		return a.BrainsEaten > b.BrainsEaten
	end)

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
		if pl.DamageDealt and pl.DamageDealt[TEAM_HUMAN] and pl.DamageDealt[TEAM_HUMAN] > 0 then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_HUMAN] == b.DamageDealt[TEAM_HUMAN] then
			return a:UserID() > b:UserID()
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
		if pl.DamageDealt and pl.DamageDealt[TEAM_UNDEAD] and pl.DamageDealt[TEAM_UNDEAD] > 0 then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_UNDEAD] == b.DamageDealt[TEAM_UNDEAD] then
			return a:UserID() > b:UserID()
		end
		return a.DamageDealt[TEAM_UNDEAD] > b.DamageDealt[TEAM_UNDEAD]
	end)

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
	ENDROUND = true
	timer.Simple(INTERMISSION_TIME, game.LoadNextMap)
	local nextmap = game.GetMapNext()

	timer.Simple(1, function()
	GAMEMODE:SendTopTimes()
	GAMEMODE:SendTopZombies()
	GAMEMODE:SendTopHumanDamages()
	GAMEMODE:SendTopZombieDamages()
	end)

	hook.Add("PlayerReady", "LateJoin", function(pl)
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

	function self:PlayerDeathThink(pl)
	end
	ROUNDWINNER = winner
	if winner == TEAM_HUMAN then
		for _, pl in pairs(player.GetAll()) do
			if pl.SpawnedTime and pl:Team() == TEAM_HUMAN then
				pl.SurvivalTime = CurTime() - pl.SpawnedTime
			end
		end
	end
	local damtoundead = 0
	local damtohumans = 0
	for _, pl in pairs(player.GetAll()) do
		if pl.DamageDealt then
			if pl.DamageDealt[TEAM_HUMAN] then
				damtoundead = damtoundead + pl.DamageDealt[TEAM_HUMAN]
			end
			if pl.DamageDealt[TEAM_UNDEAD] then
				damtohumans = damtohumans + pl.DamageDealt[TEAM_UNDEAD]
			end
		end
	end

	for _, pl in pairs(player.GetAll()) do
		pl:Lock()
		pl.NextSpawnTime = 99999
	end
end

function GM:PlayerReady(pl)
	if pl:IsValid() then
		pl:SendLua("MySelf.Class="..pl.Class.." SURVIVALMODE="..tostring(SURVIVALMODE))
		GAMEMODE:SendInflictionInit(pl)
	end
end

concommand.Add("PostPlayerInitialSpawn", function(sender, command, arguments)
	if not sender.PostPlayerInitialSpawn then
		sender.PostPlayerInitialSpawn = true

		gamemode.Call("PlayerReady", sender)
	end
end)

function GM:PlayerInitialSpawn(pl)
	pl:SetZombieClass(1)
	pl.Gibbed = false
	pl.BrainsEaten = 0
	pl.NextShove = 0
	pl.ZombiesKilled = 0
	pl.NextPainSound = 0
	pl.ZomAnim = 2
	pl.HighestAmmoType = "pistol"
	pl.DamageDealt = {}
	pl.DamageDealt[TEAM_UNDEAD] = 0
	pl.DamageDealt[TEAM_HUMAN] = 0

	if DeadSteamIDs[pl:SteamID()] then
		pl:SetTeam(TEAM_UNDEAD)
	elseif team.NumPlayers(TEAM_UNDEAD) < 1 and team.NumPlayers(TEAM_HUMAN) >= 3 then
		local plays = player.GetAll()
		local newpl = plays[math.random(1, #plays)]
		newpl:SetTeam(TEAM_UNDEAD)
		DeadSteamIDs[newpl:SteamID()] = true
		newpl:PrintMessage(4, "You've been randomly selected\nto lead the Undead army.")
		newpl:StripWeapons()
		newpl:Spawn()
		if pl ~= newpl then
			pl:SetTeam(TEAM_HUMAN)
		end
	elseif INFLICTION >= 0.5 or (CurTime() > ROUNDTIME*0.5 and HUMAN_DEADLINE) or LASTHUMAN then
		pl:SetTeam(TEAM_UNDEAD)
		DeadSteamIDs[pl:SteamID()] = true
	else
		pl:SetTeam(TEAM_HUMAN)
		pl.SpawnedTime = CurTime()
	end
	self:CalculateInfliction()
end

function GM:CheckPlayerScore(pl)
	local score = pl:Frags()
	if self.Rewards[score] then
		local reward = self.Rewards[score][math.random(1, #self.Rewards[score])]
		if string.sub(reward, 1, 1) == "_" then
			PowerupFunctions[reward](pl)
			pl:SendLua("rW()")
		elseif pl:HasWeapon(reward) then // They picked the weapon up from a dead teamate.
			local wep = pl:GetWeapon(reward)
			if wep:IsValid() then
				local ammotype = wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType or "pistol"
				pl:GiveAmmo(self.AmmoRegeneration[ammotype], ammotype, true)
			end
		else
			pl:Give(reward)
			local wep = pl:GetWeapon(reward)
			if wep:IsValid() then
				pl.HighestAmmoType = wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType
			end
		end
	end
end

function GM:PlayerNoClip(pl, on)
	return pl:IsAdmin() and ALLOW_ADMIN_NOCLIP
end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
	return true
end

function GM:OnPhysgunReload(weapon, pl)
end

function GM:PlayerDisconnected(pl)
	DeadSteamIDs[pl:SteamID()] = true
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

function GM:EntityTakeDamage(ent, attacker, inflictor, damage)
	if ent.SendLua then
		local entteam = ent:Team()
		if attacker.SendLua and attacker:Team() ~= entteam then
			local myteam = attacker:Team()
			attacker.DamageDealt[myteam] = attacker.DamageDealt[myteam] + damage

			/*if entteam == TEAM_HUMAN then
				for i=1, math.ceil(math.min(3, damage * 0.05)) do
					local effectdata = EffectData()
						effectdata:SetOrigin(ent:GetPos() + Vector(0,0,48))
						effectdata:SetMagnitude(math.random(1, 3))
					util.Effect("bloodstream", effectdata, true, true)
				end
			end*/
		end
	end

	local entclass = ent:GetClass()
	if entclass == "func_physbox" then
		ent.Heal = ent.Heal or ent:BoundingRadius() * 30
		ent.TotalHeal = ent.TotalHeal or ent.Heal

		ent.Heal = ent.Heal - damage
		local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
		local r,g,b,a = ent:GetColor()
		ent:SetColor(255, 255 * brit, 255 * brit * 0.5, a)

		if ent.Heal <= 0 then
			local foundaxis = false
			local entname = ent:GetName()
			local allaxis = ents.FindByClass("phys_hinge")
			for _, axis in pairs(allaxis) do
				local keyvalues = axis:GetKeyValues()
				if keyvalues.attach1 == entname or keyvalues.attach2 == entname then
					foundaxis = true
					axis:Remove()
					ent.Heal = ent.Heal + 120
				end
			end

			if not foundaxis then
				ent:Fire("break", "", 0)
			end
		end
	elseif entclass == "func_breakable" then
		local brit = math.Clamp(ent:Health() / ent:GetMaxHealth(), 0, 1)
		local r,g,b,a = ent:GetColor()
		ent:SetColor(255, 255 * brit, 255 * brit * 0.5, a)
	end
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if attacker.SendLua then
		if attacker:Team() == pl:Team() then
			return attacker == pl
		end
		pl.LastAttacker = attacker
	end
	pl:PlayPainSound()
	return true
end

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
	if pl and pl:IsValid() and pl:IsPlayer() then
		if pl.Gibbed or pl:Alive() or pl:Team() ~= TEAM_UNDEAD then return end
		local pos = pl:GetPos()
		local angles = pl:EyeAngles()
		local lastattacker = pl.LastAttacker
		local dclass = pl.DeathClass
		pl.DeathClass = nil
		pl:Spawn()
		pl.DeathClass = dclass
		pl.LastAttacker = lastattacker
		DeSpawnProtection(pl)
		pl:SetPos(pos)
		pl:SetHealth(pl:Health() * 0.2)
		pl:EmitSound("npc/zombie/zombie_voice_idle"..math.random( 1, 14 )..".wav", 100, 85)
		pl:SetEyeAngles(angles)
		timer.Destroy(pl:UniqueID().."secondwind")
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
end

function GM:PlayerDeathSound()
	return true
end

function GM:CanPlayerSuicide(pl)
	if pl:Team() == TEAM_HUMAN and CurTime() < ROUNDTIME * 0.1 then
		pl:PrintMessage(4, "Give others time to spawn before suiciding.")
		return false
	end

	return true
end

local function ChemBomb(pl, refrag)
	local effectdata = EffectData()
		effectdata:SetOrigin(pl:GetPos())
	util.Effect("chemzombieexplode", effectdata, true, true)
	--local damagescale = 150 + 150 * math.min(GetZombieFocus(pl:GetPos(), 300, 0.001, 0) - 0.3, 1)
	--util.BlastDamage(pl, pl, pl:GetPos() + Vector(0,0,16), damagescale, damagescale * 0.25)
	util.BlastDamage(pl, pl, pl:GetPos() + Vector(0,0,16), 170, 42)
	if refrag then
		pl:AddFrags(100)
	end
	if REDEEM and AUTOREDEEM then
		if pl:Frags() >= REDEEM_KILLS then
			pl:Redeem()
			timer.Destroy("Survivalist")
		end
	end
end

local function BanIdiot(pl)
	if pl:IsValid() then
		local concom = "kickid 0 "..pl:SteamID().." Attempt to use spectate exploit.\n"
		game.ConsoleCommand(concom)
		game.ConsoleCommand(concom)
		game.ConsoleCommand(concom)
		game.ConsoleCommand(concom)
		game.ConsoleCommand(concom) -- Sometimes it doesn't work once.
	end
end

function GM:DoPlayerDeath(pl, attacker, dmginfo)
	pl:SetLocalVelocity(pl:GetVelocity() * 2.5)

	pl:Freeze(false)

	local headshot
	local attach = pl:GetAttachment(1)
	if attach then
		headshot = dmginfo:IsBulletDamage() and dmginfo:GetDamagePosition():Distance(pl:GetAttachment(1).Pos) < 15
	end

	local revive = false
	local inflictor = NULL
	local suicide = false

	if (attacker == pl or attacker:IsWorld()) and pl.LastAttacker and pl.LastAttacker:IsValid() and pl.LastAttacker:Team() ~= pl:Team() then
		attacker = pl.LastAttacker
		inflictor = attacker:GetActiveWeapon()
		suicide = true
	elseif attacker and attacker:IsValid() then
		if attacker:IsPlayer() then
			local attackerteam = attacker:Team()
			if attackerteam ~= TEAM_UNDEAD and attackerteam ~= TEAM_HUMAN then
				timer.Simple(1, BanIdiot, attacker)
			end
			inflictor = attacker:GetActiveWeapon()
		elseif attacker:GetOwner():IsValid() then -- For NPC's with owners
			local owner = attacker:GetOwner()
			inflictor = attacker
			attacker = owner
		end
	end

	pl.LastAttacker = nil

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
	if ZombieClasses[pl.Class].Name == "Chem-Zombie" and pl:Team() == TEAM_UNDEAD and attacker ~= pl and not suicide then
		pl:Gib(dmginfo)
		pl.Gibbed = true
		if LASTHUMAN then
			timer.Simple(0, ChemBomb, pl, false)
		else
			pl:AddFrags(-100)
			timer.Simple(0, ChemBomb, pl, true)
		end
	elseif pl:Health() < -35 or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage() then
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
							revive = true
							pl:SetZombieClass(9)
							pl:LegsGib()
							timer.Simple(0, SecondWind, pl)
						else
							timer.Create(pl:UniqueID().."secondwind", 2, 1, SecondWind, pl)
							revive = true
						end
					else
						timer.Create(pl:UniqueID().."secondwind", 2, 1, SecondWind, pl)
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
		if attacker:IsPlayer() and attacker ~= pl then
			attacker:AddFrags(1)
			attacker.BrainsEaten = attacker.BrainsEaten + 1
			if REDEEM and AUTOREDEEM then
				if attacker:Frags() >= REDEEM_KILLS or INFINITEREDEEMS then
					if INFINITEREDEEMS then
						gmod.BroadcastLua([[InfRed("]]..attacker:Name()..[[")]])
					end
					attacker:Redeem()
					timer.Destroy("Survivalist")
				end
			end
			if not pl.Gibbed then
				pl:PlayDeathSound()
				timer.Create(pl:UniqueID().."secondwind", 2.5, 1, SecondWind, pl)
			end
		end
		if WARMUP_MODE and #player.GetAll() < WARMUP_THRESHOLD then
			pl:PrintMessage(HUD_PRINTTALK, "There are not enough people playing for you to change to the Undead. Set WARMUP_MODE in zs_options.lua to false to change this.")
		else
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
	elseif attacker:IsPlayer() then
		if headshot then
			pl:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
			local effectdata = EffectData()
				effectdata:SetOrigin(pl:GetAttachment(1).Pos)
				effectdata:SetNormal(dmginfo:GetDamageForce():Normalize())
				effectdata:SetMagnitude(dmginfo:GetDamageForce():Length() * 3)
				effectdata:SetEntity(pl)
			util.Effect("headshot", effectdata)
		end
		umsg.Start("PlayerKilledByPlayer")
			umsg.Entity(pl)
			umsg.String(inflictor:GetClass())
			umsg.Entity(attacker)
			umsg.Short(pl:Team())
			umsg.Short(attacker:Team())
			umsg.Bool(headshot)
		umsg.End()
	else
		umsg.Start("PlayerKilled")
			umsg.Entity(pl)
			umsg.String(inflictor:GetClass())
			umsg.String(attacker:GetClass())
		umsg.End()
	end
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
		if ZombieClasses[pl.Class].Name == "Chem-Zombie" then
			pl:SetMaterial("models/props_combine/tprings_globe")
		else
			pl:SetMaterial("")
		end
		pl:GodDisable()
	end
end

local VoiceSetTranslate = {}
VoiceSetTranslate["models/player/alyx.mdl"] = "female"
VoiceSetTranslate["models/player/barney.mdl"] = "male"
VoiceSetTranslate["models/player/breen.mdl"] = "male"
VoiceSetTranslate["models/player/combine_soldier.mdl"] = "combine"
VoiceSetTranslate["models/player/combine_soldier_prisonguard.mdl"] = "combine"
VoiceSetTranslate["models/player/combine_super_soldier.mdl"] = "combine"
VoiceSetTranslate["models/player/eli.mdl"] = "male"
VoiceSetTranslate["models/player/gman_high.mdl"] = "male"
VoiceSetTranslate["models/player/kleiner.mdl"] = "male"
VoiceSetTranslate["models/player/monk.mdl"] = "male"
VoiceSetTranslate["models/player/mossman.mdl"] = "female"
VoiceSetTranslate["models/player/odessa.mdl"] = "male"
VoiceSetTranslate["models/player/police.mdl"] = "combine"
VoiceSetTranslate["models/player/female_04.mdl"] = "female"
VoiceSetTranslate["models/player/female_06.mdl"] = "female"
VoiceSetTranslate["models/player/female_07.mdl"] = "female"
VoiceSetTranslate["models/player/male_02.mdl"] = "male"
VoiceSetTranslate["models/player/male_03.mdl"] = "male"
VoiceSetTranslate["models/player/male_08.mdl"] = "male"

function GM:PlayerSpawn(pl)
	pl:SetColor(255, 255, 255, 255)
	pl:SetMaterial("")
	pl.Gibbed = false
	timer.Destroy(pl:UserID().."SpawnProtection")

	local plteam = pl:Team()
	pl:ShouldDropWeapon(plteam == TEAM_HUMAN)

	if plteam == TEAM_UNDEAD then
		if pl.DeathClass then
			pl:SetZombieClass(pl.DeathClass)
			pl.DeathClass = nil
		end
		local class = pl:GetZombieClass()
		local classtab = ZombieClasses[class]
		pl:SetModel(classtab.Model)
		--if team.NumPlayers(TEAM_UNDEAD) <= 1 then
			--pl:SetHealth(classtab.Health * 2)
		--else
			pl:SetHealth(classtab.Health)
		--end
		pl:Give(classtab.SWEP)
		self:SetPlayerSpeed(pl, classtab.Speed)
		//pl.PlayerFootstep = classtab.PlayerFootstep ~= nil
		pl:SetNoTarget(true)
		pl:SendLua("ZomC()")
		pl:SetMaxHealth(1) -- To prevent picking up health packs
		if INFLICTION < 0.5 then
			SpawnProtection(pl, 5 - INFLICTION * 5) -- Less infliction, more spawn protection.
		end
	elseif plteam == TEAM_HUMAN then
		//pl.PlayerFootstep = nil
		local modelname = string.lower(player_manager.TranslatePlayerModel(pl:GetInfo("cl_playermodel")))
		if self.RestrictedModels[modelname] then
			modelname = "models/player/alyx.mdl"
		end
		pl:SetModel(modelname)
		pl.VoiceSet = VoiceSetTranslate[modelname] or "male"
		self:SetPlayerSpeed(pl, 200)//170)
		for _, wep in pairs(self.STARTLOADOUTS[math.random(1, #self.STARTLOADOUTS)]) do
			pl:Give(wep)
		end
		pl:SetNoTarget(false)
		pl:SendLua("HumC()")
		pl:SetMaxHealth(100)
	else
		BanIdiot(pl)
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

function GM:ScalePlayerDamage(pl, hitgroup, dmginfo)
	if pl:Team() == TEAM_HUMAN then
		dmginfo:ScaleDamage(0)
	elseif hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(2)
	else
		dmginfo:ScaleDamage(0.75)
	end

	return dmginfo
end

/*function GM:PlayerFootstep(pl, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return pl.PlayerFootstep
end*/

function GM:PlayerSwitchFlashlight(pl, switchon)
	if switchon then return pl:Team() == TEAM_HUMAN end

	return true
end

function ThrowHeadcrab(owner, wep)
	if not owner:IsValid() then return end
	if not owner:IsPlayer() then return end
	if not wep.Weapon then return end
	if owner:Alive() and owner:Team() == TEAM_UNDEAD and owner.Class == 3 then
		wep.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
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

concommand.Add("zs_class", function(sender, command, arguments)
	if arguments[1] == nil then return end
	if sender:Team() ~= TEAM_UNDEAD or timer.IsTimer(sender:UniqueID().."secondwind") then return end
	arguments = table.concat(arguments, " ")
	for i=1, #ZombieClasses do
		if string.lower(ZombieClasses[i].Name) == string.lower(arguments) then
			if ZombieClasses[i].Hidden then
				sender:PrintMessage(HUD_PRINTTALK, "AND STOP SHOUTING! I'M NOT DEAF!")
			elseif ZombieClasses[i].Threshold > INFLICTION and not ZombieClasses[i].Unlocked then
				sender:PrintMessage(HUD_PRINTTALK, "There are too many living to use that class. Kill some more humans to unlock it.")
			elseif sender.Class == i and not sender.DeathClass then
				sender:PrintMessage(HUD_PRINTTALK, "You are already a "..ZombieClasses[i].Name.."!")
			else
				sender:PrintMessage(HUD_PRINTTALK, "You will respawn as a "..ZombieClasses[i].Name..".")
				sender.DeathClass = i
			end
		    return
		end
	end
end)

concommand.Add("water_death", function(sender, command, arguments)
	if sender:Alive() then
		sender:Kill()
		sender:EmitSound("player/pl_drown"..math.random(1, 3)..".wav")
	end
end)

concommand.Add("cramped_death", function(sender, command, arguments)
	if sender:Alive() then
		sender:TakeDamage(200, NULL)
		for _, pl in pairs(player.GetAll()) do
			pl:PrintMessage(HUD_PRINTTALK, sender:Name().."'s spine crumbled in to dust.")
		end
	end
end)

concommand.Add("glitched_death", function(sender, command, arguments)
	if sender:Alive() then
		sender:TakeDamage(200, NULL)
		for _, pl in pairs(player.GetAll()) do
			pl:PrintMessage(HUD_PRINTTALK, sender:Name().." fell off the edge of the world.")
		end
	end
end)

util.PrecacheSound("ambient/voices/citizen_punches2.wav")
concommand.Add("Shove", function(sender, command, arguments)
	if not ALLOW_SHOVE then return end
	if not (sender:Alive() and sender:Team() == TEAM_HUMAN and CurTime() >= sender.NextShove) then return end
	local ent = Entity(tonumber(arguments[1]))
	if not (ent and ent:IsValid() and ent:IsPlayer() and ent:Team() == TEAM_HUMAN) then return end
	local shootpos = sender:GetShootPos()
	if shootpos:Distance(ent:GetPos() + Vector(0,0,36)) <= 50 then
		local vVel = sender:GetAimVector()
		vVel.z = 0
		local _start = ent:GetPos() + vVel * 32
		local tr = util.TraceLine({start = _start, endpos = _start - Vector(0,0,32)})
		if tr.Hit then
			sender.NextShove = CurTime() + 1.5
			ent:EmitSound("ambient/voices/citizen_punches2.wav", 80, math.random(76, 85))
			ent:SetVelocity(vVel:Normalize() * 340 + Vector(0,0,32))
		end
	end
end)

util.PrecacheSound("player/pl_pain5.wav")
util.PrecacheSound("player/pl_pain6.wav")
util.PrecacheSound("player/pl_pain7.wav")
function DoPoisoned(ent, owner, timername)
	if not (ent:IsValid() and ent:Alive()) then
		timer.Destroy(timername)
		return
	end

	ent:ViewPunch(Angle(math.random(-10, 10), math.random(-10, 10), math.random(-20, 20)))

	local damage = math.random(3, 4)

	if ent:Health() > damage then
		ent:SetHealth(ent:Health() - damage)
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
		ent:SendLua("PoisEff()")
	else
		ent:TakeDamage(damage, owner)
	end
end
