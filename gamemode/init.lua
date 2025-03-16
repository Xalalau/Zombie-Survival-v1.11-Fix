util.AddNetworkString("RcHCScale")
util.AddNetworkString("SetInf")
util.AddNetworkString("SetInfInit")
util.AddNetworkString("RcTopTimes")
util.AddNetworkString("RcTopZombies")
util.AddNetworkString("RcTopHumanDamages")
util.AddNetworkString("RcTopZombieDamages")
util.AddNetworkString("PlayerKilledSelf")
util.AddNetworkString("PlayerKilledByPlayer")
util.AddNetworkString("PlayerKilled")
util.AddNetworkString("PlayerRedeemed")
util.AddNetworkString("PlayerKilledNPC")
util.AddNetworkString("NPCKilledNPC")
util.AddNetworkString("FixClCvars")

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

do
	local files, directories = file.Find("gamemodes/zombiesurvival/gamemode/zombieanims/*.lua", "GAME")

	for k, _file in ipairs(files) do
		AddCSLuaFile("zombieanims/" .. _file)
	end
end
AddCSLuaFile("animations.lua")

AddCSLuaFile("zs_options.lua")

AddCSLuaFile("vgui/scoreboard.lua")
AddCSLuaFile("vgui/poptions.lua")
AddCSLuaFile("vgui/phelp.lua")
AddCSLuaFile("vgui/pclasses.lua")

AddCSLuaFile("cl_splitmessage.lua")

include("shared.lua")
include("powerups.lua")

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
ROUNDWINNER = NULL

local cvar_zs_ammo_regenerate_rate = GetConVar("zs_ammo_regenerate_rate")
local cvar_zs_difficulty = GetConVar("zs_difficulty")
local cvar_zs_roundtime = GetConVar("zs_roundtime")
local cvar_zs_allow_map_npcs = GetConVar("zs_allow_map_npcs")
local cvar_zs_npcs_count_as_kills = GetConVar("zs_npcs_count_as_kills")
local cvar_zs_destroy_doors = GetConVar("zs_destroy_doors")
local cvar_zs_destroy_prop_doors = GetConVar("zs_destroy_prop_doors")
local cvar_zs_allow_redeeming = GetConVar("zs_allow_redeeming")
local cvar_zs_autoredeem = GetConVar("zs_autoredeem")
local cvar_zs_redeem_kills = GetConVar("zs_redeem_kills")
local cvar_zs_warmup_mode = GetConVar("zs_warmup_mode")
local cvar_zs_warmup_threshold = GetConVar("zs_warmup_threshold")
local cvar_zs_allow_admin_noclip = GetConVar("zs_allow_admin_noclip")
local cvar_zs_human_deadline = GetConVar("zs_human_deadline")
local cvar_zs_intermission_time = GetConVar("zs_intermission_time")
local cvar_zs_allow_shove = GetConVar("zs_allow_shove")

-- Auto apply NPC configs if the player is in singleplayer mode
if game.SinglePlayer() then
	cvar_zs_allow_map_npcs:SetBool(true)
	cvar_zs_npcs_count_as_kills:SetBool(true)
end

local LastHumanSpawnPoint = NULL
local LastZombieSpawnPoint = NULL
local DeadSteamIDs = {}
local NextAmmoDropOff = cvar_zs_ammo_regenerate_rate:GetInt()

if file.Exists("gamemodes/zombiesurvival/gamemode/maps/"..game.GetMap()..".lua", "GAME") then
	include("maps/"..game.GetMap()..".lua")
end

-- HACK: force init the cvars when the gamemode is not installed in the client befored he joined the server
local function FixCLCvars(ply)
	local cvarTab = {}

	for cvarName, cvarDefault in pairs(ZSPlzFixCvars) do
		cvarTab[cvarName] = GetConVar(cvarName):GetInt()
	end

	net.Start("FixClCvars")
		net.WriteTable(cvarTab)
	net.Send(ply)
end

BroadcastLua = BroadcastLua or function(lua)
	for _, ply in ipairs(player.GetAll()) do
		ply:SendLua(lua)
	end
end

function GM:PlayerLoadout(ply)
end

function GM:GetHeadNPCScale()
	return math.Clamp(3 - cvar_zs_difficulty:GetInt(), 1.5, 4)
end

function GM:Initialize()
	resource.AddSingleFile("resource/fonts/anthem.ttf")
	resource.AddSingleFile("resource/fonts/frosty.ttf")
	for _, filename in ipairs(file.Find("materials/zombiesurvival/*.*", "THIRDPARTY")) do
		resource.AddFile("materials/zombiesurvival/"..filename)
	end
	resource.AddSingleFile("sound/ecky.wav")
	resource.AddSingleFile("sound/beat9.wav")
	resource.AddSingleFile("sound/beat8.wav")
	resource.AddSingleFile("sound/beat7.wav")
	resource.AddSingleFile("sound/beat6.wav")
	resource.AddSingleFile("sound/beat5.wav")
	resource.AddSingleFile("sound/beat4.wav")
	resource.AddSingleFile("sound/beat3.wav")
	resource.AddSingleFile("sound/beat2.wav")
	resource.AddSingleFile("sound/beat1.wav")
	resource.AddSingleFile("sound/zbeat8.wav")
	resource.AddSingleFile("sound/zbeat7.wav")
	resource.AddSingleFile("sound/zbeat6.wav")
	resource.AddSingleFile("sound/zbeat5.wav")
	resource.AddSingleFile("sound/zbeat4.wav")
	resource.AddSingleFile("sound/zbeat3.wav")
	resource.AddSingleFile("sound/zbeat2.wav")
	resource.AddSingleFile("sound/zbeat1.wav")
	resource.AddFile("materials/zombohead.vtf")
	resource.AddFile("materials/humanhead.vtf")
	resource.AddFile("materials/killicon/zs_zombie.vtf")
	resource.AddFile("materials/killicon/redeem.vtf")
	resource.AddFile("models/weapons/v_zombiearms.mdl")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet.vtf")
	resource.AddFile("materials/models/weapons/v_zombiearms/zombie_classic_sheet_normal.vtf")
	resource.AddFile("models/weapons/v_fza.mdl")
	resource.AddFile("models/weapons/v_pza.mdl")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet.vtf")
	resource.AddFile("materials/models/weapons/v_fza/fast_zombie_sheet_normal.vtf")
	resource.AddSingleFile("sound/"..LASTHUMANSOUND)
	resource.AddSingleFile("sound/"..ALLLOSESOUND)
	resource.AddSingleFile("sound/"..HUMANWINSOUND)
	resource.AddSingleFile("sound/"..DEATHSOUND)
	resource.AddSingleFile("sound/unlife1.mp3")
	//resource.AddFile("sound/unlife2.mp3")
	//resource.AddFile("sound/unlife3.mp3")

	for _, filename in ipairs(file.Find("materials/models/weapons/v_pza/*.*", "THIRDPARTY")) do
		resource.AddFile("materials/models/weapons/v_pza/"..string.lower(filename))
	end

	RunConsoleCommand("mp_mm_max_spectators", "0")
	RunConsoleCommand("mp_allowspectators", "0")
end

function GM:UnlockAllWeapons(sender)
	if sender.IsAdmin and sender:IsAdmin() then
		for _, scoreweapons in pairs(self.Rewards) do
			for __, weapon in ipairs(scoreweapons) do
				for ___, ply in ipairs(player.GetAll()) do
					if ply:Team() ~= TEAM_HUMAN then
						continue
					end

					if ply:HasWeapon(weapon) then
						local wep = ply:GetWeapon(weapon)
						if wep:IsValid() then
							local ammotype = wep:GetPrimaryAmmoTypeString() or ply.HighestAmmoType or "pistol"
							ply:GiveAmmo(self.AmmoRegeneration[ammotype], ammotype, true)
						end
					else
						ply:Give(weapon)
						local wep = ply:GetWeapon(weapon)
						if wep:IsValid() then
							ply.HighestAmmoType = wep:GetPrimaryAmmoTypeString() or ply.HighestAmmoType
						end
					end
				end
			end
		end

		print("All weapons are unlocked")
		BroadcastLua("GAMEMODE:SplitMessage(h * 0.7, '<color=red><font=HUDFontAA>All weapons unlocked!</font></color>')")
	end
end
concommand.Add("zs_unlock_all_weapons", function(sender, command, arguments) GAMEMODE:UnlockAllWeapons(sender) end)

function GM:UnlockAllClasses(sender)
	if sender.IsAdmin and sender:IsAdmin() then
		print("All zombie classes are unlocked")
		for _,class in ipairs(ZombieClasses) do class.Unlocked=true end
			BroadcastLua("for _,class in ipairs(ZombieClasses) do class['Threshold']=0 print('Unlocked ' .. class['Name']) end GAMEMODE:SplitMessage(h * 0.7, '<color=red><font=HUDFontAA>All zombies unlocked!</font></color>')")
	end
end
concommand.Add("zs_unlock_all_classes", function(sender, command, arguments) GAMEMODE:UnlockAllClasses(sender) end)

function GM:ShowHelp(ply)
	ply:SendLua("MakepHelp()")
end
concommand.Add("gm_help", function(sender, command, arguments) GAMEMODE:ShowHelp(sender) end)

function GM:ShowTeam(ply)
	if cvar_zs_allow_redeeming:GetBool() and not cvar_zs_autoredeem:GetBool() and ply:Team() == TEAM_UNDEAD and ply:Frags() >= cvar_zs_redeem_kills:GetInt() then
		ply:Redeem()
	end
end

function GM:ShowSpare1(ply)
	if ply:Team() == TEAM_UNDEAD then
		ply:SendLua("MakepClasses()")
	end
end

function GM:ShowSpare2(ply)
	ply:SendLua("MakepOptions()")
end

function GM:InitPostEntity()
	self.UndeadSpawnPoints = {}
	self.UndeadSpawnPoints = ents.FindByClass("info_player_undead")
	self.UndeadSpawnPoints = table.Add(self.UndeadSpawnPoints, ents.FindByClass("info_player_zombie"))
	self.UndeadSpawnPoints = table.Add(self.UndeadSpawnPoints, ents.FindByClass("info_player_rebel"))

	self.HumanSpawnPoints = {}
	self.HumanSpawnPoints = ents.FindByClass("info_player_human")
	self.HumanSpawnPoints = table.Add(self.HumanSpawnPoints, ents.FindByClass("info_player_combine"))

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
	for _, oldspawn in ipairs(ents.FindByClass("gmod_player_start")) do
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

	RunConsoleCommand("sk_zombie_health", math.ceil(50 + 50 * cvar_zs_difficulty:GetInt()))
	RunConsoleCommand("sk_zombie_dmg_one_slash", math.ceil(20 + cvar_zs_difficulty:GetInt() * 10))
	RunConsoleCommand("sk_zombie_dmg_both_slash", math.ceil(30 + cvar_zs_difficulty:GetInt() * 12))

	local destroying = ents.FindByClass("prop_ragdoll") // These seem to cause server crashes if a zombie attacks them. They cause pointless lag, too.
	if not cvar_zs_allow_map_npcs:GetBool() then
		destroying = table.Add(destroying, ents.FindByClass("npc_zombie"))
		destroying = table.Add(destroying, ents.FindByClass("npc_maker"))
		destroying = table.Add(destroying, ents.FindByClass("npc_template_maker"))
		destroying = table.Add(destroying, ents.FindByClass("npc_maker_template"))
	end
	if cvar_zs_destroy_doors:GetBool() then
		destroying = table.Add(destroying, ents.FindByClass("func_door_rotating"))
		destroying = table.Add(destroying, ents.FindByClass("func_door"))
	end
	if cvar_zs_destroy_prop_doors:GetBool() then
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

	for _, ent in ipairs(ents.FindByClass("prop_door_rotating")) do
		ent.AntiDoorSpam = -10
	end

	self.MapEditorEntities = {}
	file.CreateDir("zsmaps")
	if file.Exists("zsmaps/"..game.GetMap()..".txt", "DATA") then
		for _, stuff in pairs(string.Explode(",", file.Read("zsmaps/"..game.GetMap()..".txt", "DATA"))) do
			local expstuff = string.Explode(" ", stuff)
			local ent = ents.Create(expstuff[1])
			if ent:IsValid() then
				ent:SetPos(Vector(tonumber(expstuff[2]), tonumber(expstuff[3]), tonumber(expstuff[4])))
				for i=5, #expstuff do
					local kv = string.Explode("�", expstuff[i])
					ent:SetKeyValue(kv[1], kv[2])
				end
				ent:Spawn()
				table.insert(self.MapEditorEntities, ent)
			end
		end
	end
end

function GM:PlayerSelectSpawn(ply)
	if ply:Team() == TEAM_UNDEAD then
		local Count = #self.UndeadSpawnPoints
		if Count == 0 then return ply end
		for i=0, 20 do
			local ChosenSpawnPoint = self.UndeadSpawnPoints[math.random(1, Count)]
			if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint:IsInWorld() and ChosenSpawnPoint ~= LastZombieSpawnPoint then
				local blocked = false
				for _, ent in ipairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-48, -48, 0), ChosenSpawnPoint:GetPos() + Vector(48, 48, 60))) do
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
		if Count == 0 then return ply end
		for i=0, 20 do
			local ChosenSpawnPoint = self.HumanSpawnPoints[math.random(1, Count)]
			if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint:IsInWorld() and ChosenSpawnPoint ~= LastHumanSpawnPoint then
				local blocked = false
				for _, ent in ipairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-48, -48, 0), ChosenSpawnPoint:GetPos() + Vector(48, 48, 60))) do
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
	return ply
end

function GM:SendInfliction(to)
	net.Start("SetInf")
		net.WriteFloat(INFLICTION)
	if IsValid(to) then
		net.Send(to)
	else
		net.Broadcast()
	end
end

function GM:SendInflictionInit(to)
	net.Start("SetInfInit")
		net.WriteFloat(INFLICTION)
	if IsValid(to) then
		net.Send(to)
	else
		net.Broadcast()
	end
end

function GM:Think()
	local tim = CurTime()

	if cvar_zs_roundtime:GetInt() < tim then
		self:EndRound(TEAM_HUMAN)
	elseif NextAmmoDropOff < tim then
		if SURVIVALMODE then
			NextAmmoDropOff = 99999
			return
		end

		NextAmmoDropOff = CurTime() + cvar_zs_ammo_regenerate_rate:GetInt()
		INFLICTION = math.max(INFLICTION, CurTime() / cvar_zs_roundtime:GetInt())
		CAPPED_INFLICTION = INFLICTION

		self:SendInfliction()

		local plays = player.GetAll()
		if 0.75 <= INFLICTION then plays = table.Add(plays, player.GetAll()) end -- Double ammo on horde conditions

		for _, ply in pairs(plays) do
			if ply:Team() == TEAM_HUMAN then
				local wep = ply:GetActiveWeapon()
				if wep:IsValid() and wep:IsWeapon() then
					local typ = wep:GetPrimaryAmmoTypeString()
					if typ == "none" then
						if ply.HighestAmmoType == "none" then
							ply.HighestAmmoType = "pistol"
						end
						ply:GiveAmmo(self.AmmoRegeneration[ply.HighestAmmoType], ply.HighestAmmoType, true)
					else
						ply:GiveAmmo(self.AmmoRegeneration[typ], typ, true)
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
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() == TEAM_UNDEAD then
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
	if cvar_zs_npcs_count_as_kills:GetBool() and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN then
		attacker:AddFrags(1)
		self:CheckPlayerScore(attacker)
	end
end

function GM:LastHuman()
	if LASTHUMAN then return end

	BroadcastLua("GAMEMODE:LastHuman()")
	LASTHUMAN = true
end

function GM:SendTopTimes(to)
	local PlayerSorted = {}

	for k, v in ipairs(player.GetAll()) do
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
	for _, ply in ipairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			net.Start("RcTopTimes")
				net.WriteInt(x, 16)
				net.WriteString(ply:Name()..": "..ToMinutesSeconds(ply.SurvivalTime))
			if IsValid(to) then
				net.Send(to)
			else
				net.Broadcast()
			end
		end
	end
end

function GM:SendTopZombies(to)
	local PlayerSorted = {}

	for k, v in ipairs(player.GetAll()) do
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
	for _, ply in ipairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			net.Start("RcTopZombies")
				net.WriteInt(x, 16)
				net.WriteString(ply:Name()..": "..ply.BrainsEaten)
			if IsValid(to) then
				net.Send(to)
			else
				net.Broadcast()
			end
		end
	end
end

function GM:SendTopHumanDamages(to)
	local PlayerSorted = {}

	for _, ply in ipairs(player.GetAll()) do
		if ply.DamageDealt and ply.DamageDealt[TEAM_HUMAN] and ply.DamageDealt[TEAM_HUMAN] > 0 then
			table.insert(PlayerSorted, ply)
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
	for _, ply in ipairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			net.Start("RcTopHumanDamages")
				net.WriteInt(x, 16)
				net.WriteString(ply:Name()..": "..math.ceil(ply.DamageDealt[TEAM_HUMAN]))
			if IsValid(to) then
				net.Send(to)
			else
				net.Broadcast()
			end
		end
	end
end

function GM:SendTopZombieDamages(to)
	local PlayerSorted = {}

	for _, ply in ipairs(player.GetAll()) do
		if ply.DamageDealt and ply.DamageDealt[TEAM_UNDEAD] and ply.DamageDealt[TEAM_UNDEAD] > 0 then
			table.insert(PlayerSorted, ply)
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
	for _, ply in ipairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			net.Start("RcTopZombieDamages")
				net.WriteInt(x, 16)
				net.WriteString(ply:Name()..": "..math.ceil(ply.DamageDealt[TEAM_UNDEAD]))
			if IsValid(to) then
				net.Send(to)
			else
				net.Broadcast()
			end
		end
	end
end

hook.Add("MapVoteChange", "OverrideNextMap", function(overrideNextMap)
	RunConsoleCommand("nextlevel", overrideNextMap)

	net.Start("RAM_MapVoteCancel")
	net.Broadcast()

	timer.Destroy("RAM_MapVote")

	return false
end)

function GM:EndRound(winner)
	if ENDROUND then return end
	ENDROUND = true
	timer.Simple(cvar_zs_intermission_time:GetInt(), game.LoadNextMap)
	timer.Simple(cvar_zs_intermission_time:GetInt() * 0.3, function() hook.Run("LoadNextMap") end)

	DeadSteamIDs = {}

	timer.Simple(1, function()
		GAMEMODE:SendTopTimes()
		GAMEMODE:SendTopZombies()
		GAMEMODE:SendTopHumanDamages()
		GAMEMODE:SendTopZombieDamages()
	end)

	hook.Add("PlayerReady", "LateJoin", function(ply)
		ply:SendLua("Intermission("..ROUNDWINNER..")")
		GAMEMODE:SendTopTimes(ply)
		GAMEMODE:SendTopZombies(ply)
		GAMEMODE:SendTopHumanDamages(ply)
		GAMEMODE:SendTopZombieDamages(ply)
	end)
	hook.Add("PlayerSpawn", "LateJoin2", function(ply)
		ply:Lock()
	end)
	BroadcastLua("Intermission("..winner..")")

	function self:PlayerDeathThink(ply)
	end
	ROUNDWINNER = winner
	if winner == TEAM_HUMAN then
		for _, ply in ipairs(player.GetAll()) do
			if ply.SpawnedTime and ply:Team() == TEAM_HUMAN then
				ply.SurvivalTime = CurTime() - ply.SpawnedTime
			end
		end
	end
	local damtoundead = 0
	local damtohumans = 0
	for _, ply in ipairs(player.GetAll()) do
		if ply.DamageDealt then
			if ply.DamageDealt[TEAM_HUMAN] then
				damtoundead = damtoundead + ply.DamageDealt[TEAM_HUMAN]
			end
			if ply.DamageDealt[TEAM_UNDEAD] then
				damtohumans = damtohumans + ply.DamageDealt[TEAM_UNDEAD]
			end
		end
	end

	for _, ply in ipairs(player.GetAll()) do
		ply:Lock()
		ply.NextSpawnTime = 99999
	end
end

function GM:PlayerReady(ply)
	-- Reliable place to send net messages to new players spawning for the first time
	if not ply:IsValid() then return end

	ply:SendLua("LocalPlayer().Class="..ply.Class.." SURVIVALMODE="..tostring(SURVIVALMODE))
	GAMEMODE:SendInflictionInit(ply)

	FixCLCvars(ply)

	for SteamID64, zombiePly in pairs(DeadSteamIDs) do
		if not IsValid(zombiePly) then
			zombiePly = player.GetBySteamID64(SteamID64)

			if not IsValid(zombiePly) then
				continue
			end

			DeadSteamIDs[SteamID64] = zombiePly
		end

		local index = zombiePly:EntIndex()
		local cl = zombiePly.Class

		ply:SendLua("ents.GetByIndex(" .. index .. ").Class="..cl)
	end
end

concommand.Add("PostPlayerInitialSpawn", function(sender, command, arguments)
	if not sender.PostPlayerInitialSpawn then
		sender.PostPlayerInitialSpawn = true

		gamemode.Call("PlayerReady", sender)
	end
end)

function GM:PlayerInitialSpawn(ply)
	-- This sets the player zombie class after the first death. 1 is the normal zombie.
	ply.DeathClass = 1
	ply:SetZombieClass(1)

	ply.Gibbed = false
	ply.BrainsEaten = 0
	ply.NextShove = 0
	ply.ZombiesKilled = 0
	ply.NextPainSound = 0
	ply.ZomAnim = 2
	ply.HighestAmmoType = "pistol"
	ply.DamageDealt = {}
	ply.DamageDealt[TEAM_UNDEAD] = 0
	ply.DamageDealt[TEAM_HUMAN] = 0

	if DeadSteamIDs[ply:SteamID64()] then
		ply:SetTeam(TEAM_UNDEAD)
	elseif team.NumPlayers(TEAM_UNDEAD) < 1 and team.NumPlayers(TEAM_HUMAN) >= 3 then
		local plays = player.GetAll()
		local newply = plays[math.random(1, #plays)]
		newply:SetTeam(TEAM_UNDEAD)
		DeadSteamIDs[newply:SteamID64()] = newply
		newply:PrintMessage(4, "You've been randomly selected\nto lead the Undead army.")
		newply:StripWeapons()
		newply:Spawn()
		if ply ~= newply then
			ply:SetTeam(TEAM_HUMAN)
		end
	elseif INFLICTION >= 0.5 or (CurTime() > cvar_zs_roundtime:GetInt()*0.5 and cvar_zs_human_deadline:GetBool()) or LASTHUMAN then
		ply:SetTeam(TEAM_UNDEAD)
		DeadSteamIDs[ply:SteamID64()] = ply
	else
		ply:SetTeam(TEAM_HUMAN)
		ply.SpawnedTime = CurTime()
	end
	self:CalculateInfliction()
	ply:Unstuck()
end

function GM:CheckPlayerScore(ply)
	local score = ply:Frags()
	if self.Rewards[score] then
		local reward = self.Rewards[score][math.random(1, #self.Rewards[score])]
		if string.sub(reward, 1, 1) == "_" then
			PowerupFunctions[reward](ply)
			ply:SendLua("rW()")
		elseif ply:HasWeapon(reward) then // They picked the weapon up from a dead teamate.
			local wep = ply:GetWeapon(reward)
			if wep:IsValid() then
				local ammotype = wep:GetPrimaryAmmoTypeString() or ply.HighestAmmoType or "pistol"
				ply:GiveAmmo(self.AmmoRegeneration[ammotype], ammotype, true)
			end
		else
			ply:Give(reward)
			local wep = ply:GetWeapon(reward)
			if wep:IsValid() then
				ply.HighestAmmoType = wep:GetPrimaryAmmoTypeString() or ply.HighestAmmoType
			end
		end
	end
end

function GM:PlayerNoClip(ply, on)
	return ply:IsAdmin() and cvar_zs_allow_admin_noclip:GetBool()
end

function GM:OnPhysgunFreeze(weapon, phys, ent, ply)
	return true
end

function GM:OnPhysgunReload(weapon, ply)
end

function GM:PlayerDisconnected(ply)
	DeadSteamIDs[ply:SteamID64()] = ply
	timer.Simple(2, function()
		if IsValid(self) then
			self:CalculateInfliction()
		end
	end)
end

function GM:PlayerSay(ply, text, teamonly)
	return text
end

function GM:PlayerDeathThink(ply)
	if CurTime() > ply.NextSpawnTime then
		if ply:Team() == TEAM_UNDEAD then
			if ply:KeyDown(IN_ATTACK) then
				ply:Spawn()
			end
		else
			ply:Spawn()
		end
	end
end

function GM:PlayerHurt(victim, attacker, healthRemaining, damageTaken)
	if not damageTaken then return end
	if not attacker:IsPlayer() and victim:IsPlayer() then return end

	if victim:Team() == TEAM_HUMAN then
		for i=1, math.ceil(math.min(3, damageTaken * 0.05)) do
			local effectdata = EffectData()
				effectdata:SetOrigin(victim:GetPos() + Vector(0,0,48))
				effectdata:SetMagnitude(math.random(1, 3))
			util.Effect("bloodstream", effectdata, true, true)
		end
	end

	local victimteam = victim:Team()
	if attacker:Team() ~= victimteam then
		local myteam = attacker:Team()
		attacker.DamageDealt[myteam] = attacker.DamageDealt[myteam] + damageTaken
	end
end

function GM:EntityTakeDamage(ent, attacker, inflictor, damage)
	if not damage then return end

	local entclass = ent:GetClass()
	if entclass == "func_physbox" then
		ent.Heal = ent.Heal or ent:BoundingRadius() * 30
		ent.TotalHeal = ent.TotalHeal or ent.Heal

		ent.Heal = ent.Heal - damage
		local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
		local r,g,b,a = ent:GetColor()
		ent:SetColor(Color(255, 255 * brit, 255 * brit * 0.5, a))

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
		ent:SetColor(Color(255, 255 * brit, 255 * brit * 0.5, a))
	end
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if attacker.SendLua then
		if attacker:Team() == ply:Team() then
			return attacker == ply
		end
		ply.LastAttacker = attacker
	end
	ply:PlayPainSound()
	return true
end

function GM:PlayerUse(ply, entity)
	if not entity then return end
	if not entity:IsValid() then return end
	if ply:Team() == TEAM_UNDEAD then
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

function SecondWind(ply)
	if ply and ply:IsValid() and ply:IsPlayer() then
		if ply.Gibbed or ply:Alive() or ply:Team() ~= TEAM_UNDEAD then return end
		local pos = ply:GetPos()
		local angles = ply:EyeAngles()
		local lastattacker = ply.LastAttacker
		local dclass = ply.DeathClass
		ply.DeathClass = nil
		ply:Spawn()
		ply.DeathClass = dclass
		ply.LastAttacker = lastattacker
		DeSpawnProtection(ply)
		ply:SetPos(pos)
		ply:SetHealth(ply:Health() * 0.2)
		ply:EmitSound("npc/zombie/zombie_voice_idle"..math.random( 1, 14 )..".wav", 100, 85)
		ply:SetEyeAngles(angles)
		timer.Remove(ply:UniqueID().."secondwind")
	end
end

function GM:PlayerDeath(victim, inflictor, attacker)
end

function GM:PlayerDeathSound()
	return true
end

function GM:CanPlayerSuicide(ply)
	if SUPPRESS_SUICIDE and ply:Team() == TEAM_HUMAN and CurTime() < cvar_zs_roundtime:GetInt() * 0.1 then
		ply:PrintMessage(4, "Give others time to spawn before suiciding.")
		return false
	end

	return true
end

local function ChemBomb(ply, refrag)
	local effectdata = EffectData()
		effectdata:SetOrigin(ply:GetPos())
	util.Effect("chemzombieexplode", effectdata, true, true)
	--local damagescale = 150 + 150 * math.min(GetZombieFocus(ply:GetPos(), 300, 0.001, 0) - 0.3, 1)
	--util.BlastDamage(ply, ply, ply:GetPos() + Vector(0,0,16), damagescale, damagescale * 0.25)
	--util.BlastDamage(ply, ply, ply:WorldSpaceCenter(), 170, 42)

	local dmg = DamageInfo() -- Manually apply blast damage, as util.BlastDamage seems to fail when chem zombie and players are over displacements - Xala 
	dmg:SetDamage(42)
	dmg:SetAttacker(ply)
	dmg:SetInflictor(ply)
	dmg:SetDamageType(DMG_BLAST)

	for k, ent in ipairs(ents.FindInSphere(ply:WorldSpaceCenter(), 170)) do
		if ent:IsValid() and ent:IsPlayer() and ent ~= ply then
			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ent:EyePos(),
				filter = function(hitent)
					return hitent:IsValid() and hitent.GetClass and hitent:GetClass() ~= "playergib" or false
				end
			})

			if tr.Entity:IsValid() and tr.Entity:IsPlayer() or
			   not tr.Entity:IsValid() and (not tr.Entity.IsWorld or not tr.Entity:IsWorld())
			then
				ent:TakeDamageInfo(dmg)
			end
		end
	end

	if refrag then
		ply:AddFrags(100)
	end
	if cvar_zs_allow_redeeming:GetBool() and cvar_zs_autoredeem:GetBool() then
		if ply:Frags() >= cvar_zs_redeem_kills:GetInt() then
			ply:Redeem()
			timer.Remove("Survivalist")
		end
	end
end

local function BanIdiot(ply)
	if ply:IsValid() then
		game.KickID(ply:SteamID64(), "Attempt to use spectate exploit.")
	end
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:SetLocalVelocity(ply:GetVelocity() * 2.5)

	ply:Freeze(false)

	local headshot
	local attach = ply:GetAttachment(1)
	if attach then
		headshot = dmginfo:IsBulletDamage() and dmginfo:GetDamagePosition():Distance(ply:GetAttachment(1).Pos) < 15
	end

	local revive = false
	local inflictor = NULL
	local suicide = false

	if (attacker == ply or attacker:IsWorld()) and ply.LastAttacker and ply.LastAttacker:IsValid() and ply.LastAttacker:Team() ~= ply:Team() then
		attacker = ply.LastAttacker
		inflictor = attacker:GetActiveWeapon()
		suicide = true
	elseif attacker and attacker:IsValid() then
		if attacker:IsPlayer() then
			local attackerteam = attacker:Team()
			if attackerteam ~= TEAM_UNDEAD and attackerteam ~= TEAM_HUMAN then
				timer.Simple(1, function()
					if IsValid(attacker) then
						BanIdiot(attacker)
					end
				end)
			end
			inflictor = attacker:GetActiveWeapon()
		elseif attacker:GetOwner():IsValid() then -- For NPC's with owners
			local owner = attacker:GetOwner()
			inflictor = attacker
			attacker = owner
		end
	end

	ply.LastAttacker = nil

	if inflictor == NULL then inflictor = attacker end

	if ply.Headcrabz then
		for _, headcrab in pairs(ply.Headcrabz) do
			if headcrab:IsValid() and headcrab:IsNPC() then
				headcrab:Fire("sethealth", "0", 5)
			end
		end
	end

	ply.NextSpawnTime = CurTime() + 4
	ply:AddDeaths(1)
	if ZombieClasses[ply.Class].Name == "Chem-Zombie" and ply:Team() == TEAM_UNDEAD and attacker ~= ply and not suicide then
		ply:Gib(dmginfo)
		ply.Gibbed = true
		if LASTHUMAN then
			timer.Simple(0, function()
				if IsValid(ply) then
					ChemBomb(ply, false)
				end
			end)
		else
			ply:AddFrags(-100)
			timer.Simple(0, function()
				if IsValid(ply) then
					ChemBomb(ply, true)
				end
			end)
		end
	elseif ply:Health() < -35 or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage() then
		ply:Gib(dmginfo)
		ply.Gibbed = true
	else
		ply:CreateRagdoll()
	end

	if ply:Team() == TEAM_UNDEAD then
		if attacker:IsValid() and attacker:IsPlayer() and attacker ~= ply then
			if ZombieClasses[ply.Class].Revives then
				if not ply.Gibbed and not headshot and math.random(1, 4) ~= 1 then
					if ply.Class == 1 then
						if math.random(1, 3) == 3 then
							revive = true
							ply:SetZombieClass(9)
							ply:LegsGib()
							timer.Simple(0, function()
								if IsValid(ply) then
									SecondWind(ply)
								end
							end)
						else
							timer.Create(ply:UniqueID().."secondwind", 2, 1, function()
								if IsValid(ply) then
									SecondWind(ply)
								end
							end)
							revive = true
						end
					else
						timer.Create(ply:UniqueID().."secondwind", 2, 1, function()
							if IsValid(ply) then
								SecondWind(ply)
							end
						end)
						revive = true
					end
				else
					attacker:AddFrags(1)
					attacker.ZombiesKilled = attacker.ZombiesKilled + 1
					ply:PlayZombieDeathSound()
					self:CheckPlayerScore(attacker)
				end
			else
				attacker:AddFrags(1)
				attacker.ZombiesKilled = attacker.ZombiesKilled + 1
				ply:PlayZombieDeathSound()
				self:CheckPlayerScore(attacker)
			end
		else
			ply:PlayZombieDeathSound()
		end
	else
		if attacker:IsPlayer() and attacker ~= ply then
			attacker:AddFrags(1)
			attacker.BrainsEaten = attacker.BrainsEaten + 1
			if cvar_zs_allow_redeeming:GetBool() and cvar_zs_autoredeem:GetBool() then
				if attacker:Frags() >= cvar_zs_redeem_kills:GetInt() or INFINITEREDEEMS then
					if INFINITEREDEEMS then
						BroadcastLua([[InfRed("]]..attacker:Name()..[[")]])
					end
					attacker:Redeem()
					timer.Remove("Survivalist")
				end
			end
			if not ply.Gibbed then
				ply:PlayDeathSound()
				timer.Create(ply:UniqueID().."secondwind", 2.5, 1, function()
					if IsValid(ply) then
						SecondWind(ply)
					end
				end)
			end
		end
		if cvar_zs_warmup_mode:GetBool() and #player.GetAll() < cvar_zs_warmup_threshold:GetInt() then
			ply:PrintMessage(HUD_PRINTTALK, "There are not enough people playing for you to change to the Undead. Set zs_warmup_mode in zs_options.lua to false to change this.")
		else
			ply:SetTeam(TEAM_UNDEAD)
			DeadSteamIDs[ply:SteamID64()] = ply
		end
		ply:SendLua("Died()")
		ply:SetFrags(0)
		if ply.SpawnedTime then
			local survtime = CurTime() - ply.SpawnedTime
			if ply.SurvivalTime then
				if survtime > ply.SurvivalTime then
					ply.SurvivalTime = survtime
				end
			else
				ply.SurvivalTime = CurTime() - ply.SpawnedTime
			end
		end
		ply.SpawnedTime = nil
		self:CalculateInfliction()
	end

	if revive then return end

	if attacker == ply then
		net.Start("PlayerKilledSelf")
			net.WriteEntity(ply)
		net.Broadcast()
	elseif attacker:IsPlayer() then
		if headshot then
			ply:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
			local dmgforce = dmginfo:GetDamageForce()
			local effectdata = EffectData()
				effectdata:SetOrigin(ply:GetAttachment(1).Pos)
				effectdata:SetNormal(dmgforce:GetNormalized())
				effectdata:SetMagnitude(dmgforce:Length() * 3)
				effectdata:SetEntity(ply)
			util.Effect("headshot", effectdata)
		end
		net.Start("PlayerKilledByPlayer")
			net.WriteEntity(ply)
			net.WriteString(inflictor:GetClass())
			net.WriteEntity(attacker)
			net.WriteInt(ply:Team(), 16)
			net.WriteInt(attacker:Team(), 16)
			net.WriteBool(headshot)
		net.Broadcast()
	else
		net.Start("PlayerKilled")
			net.WriteEntity(ply)
			net.WriteString(inflictor:GetClass())
			net.WriteString(attacker:GetClass())
		net.Broadcast()
	end
end

function GM:PlayerCanPickupWeapon(ply, entity)
	if ply:Team() == TEAM_UNDEAD then return entity:GetClass() == ZombieClasses[ply.Class].SWEP end

	return true
end

function SpawnProtection(ply, tim)
	GAMEMODE:SetPlayerSpeed(ply, ZombieClasses[ply:GetZombieClass()].Speed * 1.5)
	ply:SetMaterial("models/shiny")
	ply:GodEnable()
	timer.Create(ply:UserID().."SpawnProtection", tim, 1, function()
		if IsValid(ply) then
			DeSpawnProtection(ply)
		end
	end)
end

function DeSpawnProtection(ply)
	if ply:IsValid() and ply:IsPlayer() then
		GAMEMODE:SetPlayerSpeed(ply, ZombieClasses[ply.Class].Speed)
		if ZombieClasses[ply.Class].Name == "Chem-Zombie" then
			ply:SetMaterial("models/props_combine/tprings_globe")
		else
			ply:SetMaterial("")
		end
		ply:GodDisable()
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

function GM:PlayerSpawn(ply)
	local plyteam = ply:Team()

	if plyteam == TEAM_SPECTATOR then
		ply:SetTeam(TEAM_UNDEAD)
		ply:UnSpectate()
		ply:Spawn()
		plyteam = TEAM_UNDEAD
	end

	ply:SetRenderMode(RENDERMODE_NORMAL)
	ply:DrawShadow(true)
	ply:SetColor(Color(255, 255, 255, 255))
	ply:SetMaterial("")
	ply.Gibbed = false
	timer.Remove(ply:UserID().."SpawnProtection")

	ply:ShouldDropWeapon(plyteam == TEAM_HUMAN)
	ply:Unstuck()

	if plyteam == TEAM_UNDEAD then	
		if ply.DeathClass then
			ply:SetZombieClass(ply.DeathClass)
			ply.DeathClass = nil
		end
		local class = ply:GetZombieClass()
		local classtab = ZombieClasses[class]
		ply:SetModel(classtab.Model)
		--if team.NumPlayers(TEAM_UNDEAD) <= 1 then
			--ply:SetHealth(classtab.Health * 2)
		--else
			ply:SetHealth(classtab.Health)
		--end
		ply:Give(classtab.SWEP)
		self:SetPlayerSpeed(ply, classtab.Speed)
		//ply.PlayerFootstep = classtab.PlayerFootstep ~= nil
		ply:SetNoTarget(true)
		ply:SendLua("ZomC()")
		ply:SetMaxHealth(1) -- To prevent picking up health packs
		if INFLICTION < 0.5 then
			SpawnProtection(ply, 5 - INFLICTION * 5) -- Less infliction, more spawn protection.
		end
	elseif plyteam == TEAM_HUMAN then
		//ply.PlayerFootstep = nil
		local modelname = string.lower(player_manager.TranslatePlayerModel(ply:GetInfo("cl_playermodel")))
		if self.RestrictedModels[modelname] then
			modelname = "models/player/alyx.mdl"
		end
		ply:SetModel(modelname)
		ply.VoiceSet = VoiceSetTranslate[modelname] or "male"
		self:SetPlayerSpeed(ply, 200)//170)
		for _, wep in pairs(self.STARTLOADOUTS[math.random(1, #self.STARTLOADOUTS)]) do
			ply:Give(wep)
		end
		ply:SetNoTarget(false)
		ply:SendLua("HumC()")
		ply:SetMaxHealth(100)
	else
		BanIdiot(ply)
	end

	ply.LastHealth = ply:Health()
end

function GM:WeaponEquip(weapon)
end

function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
    if hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(self:GetHeadNPCScale())
	end
	return dmginfo
end

function GM:ScalePlayerDamage(ply, hitgroup, dmginfo)
	if ply:Team() == TEAM_HUMAN then
		dmginfo:ScaleDamage(0)
	elseif hitgroup == HITGROUP_HEAD then
		dmginfo:ScaleDamage(2)
	else
		dmginfo:ScaleDamage(0.75)
	end

	return dmginfo
end

/*function GM:PlayerFootstep(ply, vFootPos, iFoot, strSoundName, fVolume, pFilter)
	return ply.PlayerFootstep
end*/

function GM:PlayerSwitchFlashlight(ply, switchon)
	if switchon then return ply:Team() == TEAM_HUMAN end

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
		local vel = eyeangles:Forward():GetNormalized()
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
			for _, ply in ipairs(player.GetAll()) do
				if ply:Team() == TEAM_UNDEAD then
					ent:AddEntityRelationship(ply, D_LI, 99)
				else
					ent:AddEntityRelationship(ply, D_HT, 99)
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
	if sender:Team() ~= TEAM_UNDEAD or timer.Exists(sender:UniqueID().."secondwind") then return end
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
				if sender:Health() > 0 then
					sender:Kill()
				end
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
		for _, ply in ipairs(player.GetAll()) do
			ply:PrintMessage(HUD_PRINTTALK, sender:Name().."'s spine crumbled in to dust.")
		end
	end
end)

concommand.Add("glitched_death", function(sender, command, arguments)
	if sender:Alive() then
		sender:TakeDamage(200, NULL)
		for _, ply in ipairs(player.GetAll()) do
			ply:PrintMessage(HUD_PRINTTALK, sender:Name().." fell off the edge of the world.")
		end
	end
end)

util.PrecacheSound("ambient/voices/citizen_punches2.wav")
concommand.Add("Shove", function(sender, command, arguments)
	if not cvar_zs_allow_shove:GetBool() then return end
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
			ent:SetVelocity(vVel:GetNormalized() * 340 + Vector(0,0,32))
		end
	end
end)

util.PrecacheSound("player/pl_pain5.wav")
util.PrecacheSound("player/pl_pain6.wav")
util.PrecacheSound("player/pl_pain7.wav")
function DoPoisoned(ent, owner, timername)
	if not (ent:IsValid() and ent:Alive()) then
		timer.Remove(timername)
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

function GM:AllowPlayerPickup(ply, ent)
	if ply:Team() == TEAM_UNDEAD then
		return false
	end

	return true
end