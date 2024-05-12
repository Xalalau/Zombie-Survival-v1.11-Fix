--[[

Zombie Survival
by William "JeBoom" Moodhe
jetboom@yahoo.com
http://www.noxiousnet.com/

Further credits displayed by pressing F1 in-game.

]]

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
AddCSLuaFile("obj_entity_extend.lua")

AddCSLuaFile("zs_options.lua")

AddCSLuaFile("vgui/scoreboard.lua")
AddCSLuaFile("vgui/poptions.lua")
AddCSLuaFile("vgui/phelp.lua")
AddCSLuaFile("vgui/pclasses.lua")
AddCSLuaFile("vgui/pweapons.lua")

AddCSLuaFile("cl_splitmessage.lua")

include("shared.lua")
include("powerups.lua")
include("animations.lua")
include("mapeditor.lua")

for i, filename in ipairs(file.FindInLua("zombieclasses")) do
	include("zombieclasses/"..filename)
	AddCSLuaFile("zombieclasses/"..filename)
end

if GM.SubVersion == "Official" and util.CRC(file.Read("../gamemodes/zombiesurvival/gamemode/zs_options.lua")) ~= "3852549224" then
	GM.SubVersion = "Modified"
end

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

function TrueVisible(posa, posb)
	local filt = ents.FindByClass("projectile_*")
	filt = table.Add(filt, ents.FindByClass("npc_*"))
	filt = table.Add(filt, player.GetAll())

	return not util.TraceLine({start = posa, endpos = posb, filter = filt}).Hit
end

function GM:Move(pl, move)
	local speed = move:GetForwardSpeed()
	local sidespeed = move:GetSideSpeed()
	if pl:Team() == TEAM_HUMAN then
		if 2 < pl:WaterLevel() and pl:Alive() then
			pl.Drowning = pl.Drowning or CurTime() + 30
			if pl.Drowning <= CurTime() then
				pl.Drowning = nil
				pl:Kill()
				pl:EmitSound("player/pl_drown"..math.random(1, 3)..".wav")
			end
		elseif pl.Drowning then
			pl.Drowning = nil
		end

		if speed < 0 and speed - math.abs(sidespeed) < -130 then -- They're walking backwards but don't slow down already slow weapons.
			move:SetForwardSpeed(speed * 0.6) -- Fraction it.
			move:SetSideSpeed(sidespeed * 0.6) -- Also fraction this.
		end
	end

	if pl:IsOnGround() then
		local plpos = pl:GetPos()
		for _, ent in pairs(player.GetAll()) do
			if ent ~= pl and ent:IsPlayer() and ent:Team() == pl:Team() and ent:Alive() then
				local entpos = ent:GetPos()
				local dist = plpos:Distance(entpos)
				if dist < 24 then
					move:SetVelocity(move:GetVelocity() + math.max(12, 24 - dist) * FrameTime() * 80 * (plpos - entpos):Normalize())
				end
			end
		end
	end
end

function GM:PlayerLoadout(pl)
end

function GM:GetLivingZombies()
	local tab = {}

	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD and not pl.Discon and pl:Alive() and not timer.IsTimer(pl:UniqueID().."secondwind") then
			table.insert(tab, pl)
		end
	end

	self.LivingZombies = #tab
	return tab
end

timer.Create("UpdateLiving", 5, 0, GM.GetLivingZombies, GM)

function GM:NumLivingZombies()
	return self.LivingZombies
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
	resource.AddFile("sound/wraithdeath1.wav")
	resource.AddFile("sound/wraithdeath2.wav")
	resource.AddFile("sound/wraithdeath3.wav")
	resource.AddFile("sound/wraithdeath4.wav")
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
	resource.AddFile("models/weapons/v_annabelle.mdl")
	resource.AddFile("materials/models/weapons/w_annabelle/gun.vtf")
	resource.AddFile("materials/models/weapons/pot.vtf")
	resource.AddFile("materials/models/weapons/pot.vmt")
	resource.AddFile("materials/models/weapons/sledge.vtf")
	resource.AddFile("materials/models/weapons/sledge.vmt")
	resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vtf")
	resource.AddFile("materials/models/weapons/temptexture/handsmesh1.vmt")
	resource.AddFile("materials/models/weapons/hammer2.vtf")
	resource.AddFile("materials/models/weapons/hammer2.vmt")
	resource.AddFile("materials/models/weapons/hammer.vtf")
	resource.AddFile("materials/models/weapons/hammer.vmt")
	resource.AddFile("materials/models/weapons/axe.vtf")
	resource.AddFile("materials/models/weapons/axe.vmt")
	resource.AddFile("materials/models/weapons/computer.vtf")
	resource.AddFile("materials/models/weapons/computer.vmt")
	resource.AddFile("materials/models/weapons/shovel.vtf")
	resource.AddFile("materials/models/weapons/shovel.vmt")
	resource.AddFile("models/weapons/w_sledgehammer.mdl")
	resource.AddFile("models/weapons/v_sledgehammer/v_sledgehammer.mdl")
	resource.AddFile("models/weapons/w_axe.mdl")
	resource.AddFile("models/weapons/v_axe/v_axe.mdl")
	resource.AddFile("models/weapons/w_hammer.mdl")
	resource.AddFile("models/weapons/v_hammer/v_hammer.mdl")
	resource.AddFile("models/weapons/w_shovel.mdl")
	resource.AddFile("models/weapons/v_shovel/v_shovel.mdl")
	resource.AddFile("models/weapons/w_plank.mdl")
	resource.AddFile("models/weapons/v_plank/v_plank.mdl")
	resource.AddFile("models/weapons/w_fryingpan.mdl")
	resource.AddFile("models/weapons/v_fryingpan/v_fryingpan.mdl")
	resource.AddFile("models/weapons/w_pot.mdl")
	resource.AddFile("models/weapons/v_pot/v_pot.mdl")
	resource.AddFile("models/weapons/w_keyboard.mdl")
	resource.AddFile("models/weapons/v_keyboard/v_keyboard.mdl")

	resource.AddFile("sound/weapons/melee/golf club/golf_hit-01.wav")
	resource.AddFile("sound/weapons/melee/golf club/golf_hit-02.wav")
	resource.AddFile("sound/weapons/melee/golf club/golf_hit-03.wav")
	resource.AddFile("sound/weapons/melee/golf club/golf_hit-04.wav")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-1.wav")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-2.wav")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-3.wav")
	resource.AddFile("sound/weapons/melee/crowbar/crowbar_hit-4.wav")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-01.wav")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-02.wav")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-03.wav")
	resource.AddFile("sound/weapons/melee/shovel/shovel_hit-04.wav")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-01.wav")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-02.wav")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-03.wav")
	resource.AddFile("sound/weapons/melee/frying_pan/pan_hit-04.wav")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-01.wav")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-02.wav")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-03.wav")
	resource.AddFile("sound/weapons/melee/keyboard/keyboard_hit-04.wav")

	resource.AddFile("materials/noxctf/sprite_bloodspray1.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray2.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray3.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray4.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray5.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray6.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray7.vmt")
	resource.AddFile("materials/noxctf/sprite_bloodspray8.vmt")

	resource.AddFile("sound/"..LASTHUMANSOUND)
	resource.AddFile("sound/"..ALLLOSESOUND)
	resource.AddFile("sound/"..HUMANWINSOUND)
	resource.AddFile("sound/"..DEATHSOUND)
	--resource.AddFile("sound/"..UNLIFESOUND)

	for _, filename in pairs(file.Find("../materials/models/weapons/v_pza/*.*")) do
		resource.AddFile("materials/models/weapons/v_pza/"..string.lower(filename))
	end

	game.ConsoleCommand("fire_dmgscale 1\nmp_flashlight 1\n")
end

function GM:ShowHelp(pl)
	pl:SendLua("MakepHelp()")
end
concommand.Add("gm_help", function(sender, command, arguments) GAMEMODE:ShowHelp(sender) end)

function GM:ShowTeam(pl)
	if REDEEM and not AUTOREDEEM and pl:Team() == TEAM_UNDEAD and REDEEM_KILLS <= pl:Frags() then
		pl:Redeem()
	end
end

function GM:ShowSpare1(pl)
	if pl:Team() == TEAM_UNDEAD then
		pl:SendLua("MakepClasses()")
	else
		pl:SendLua("MakepWeapons()")
	end
end

function GM:ShowSpare2(pl)
	pl:SendLua("MakepOptions()")
end

function GM:InitPostEntity()
	BRAINSEATEN = 0
	UNDEADSLAIN = 0

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

	local destroying = ents.FindByClass("prop_ragdoll") -- These seem to cause server crashes if a zombie attacks them. They cause pointless lag, too.
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

	if ZOMBIEGASSES then
		for _, spawn in pairs(self.UndeadSpawnPoints) do
			local gasses = ents.FindByClass("zombiegasses")
			local numgasses = #gasses
			if 4 < numgasses then
				break
			elseif math.random(1, 4) == 1 or numgasses < 1 then
				local spawnpos = spawn:GetPos()
				local nearhum = false
				for _, humspawn in pairs(self.HumanSpawnPoints) do
					if humspawn:GetPos():Distance(spawnpos) < 272 then
						nearhum = true
						break
					end
				end
				if not nearhum then
					for _, humspawn in pairs(gasses) do
						if humspawn:GetPos():Distance(spawnpos) < 128 then
							nearhum = true
							break
						end
					end
				end
				if not nearhum then
					local ent = ents.Create("zombiegasses")
					if ent:IsValid() then
						ent:SetPos(spawnpos)
						ent:Spawn()
					end
				end
			end
		end
	end

	for _, ent in pairs(ents.FindByClass("prop_door_rotating")) do
		ent.AntiDoorSpam = -10
	end

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

	for _, ent in pairs(ents.FindByClass("prop_physics*")) do
		if ent:GetModel() == "models/props_c17/tools_wrench01a.mdl" then
			local newwep = ents.Create("weapon_zs_hammer")
			if newwep:IsValid() then
				newwep:SetPos(ent:GetPos())
				newwep:Spawn()
				ent:Remove()
			else
				ent:SetModel("models/weapons/w_hammer.mdl")
			end
		end

		if ent:GetMaxHealth() == 1 and ent:Health() == 0 then
			local health = math.ceil((ent:OBBMins():Length() + ent:OBBMaxs():Length()) * 10)
			if health < 2000 then
				ent.PropHealth = health
				ent.TotalHealth = ent.PropHealth
			end
		elseif string.lower(ent:GetModel()) == "models/props_c17/oildrum001_explosive.mdl" then
			ent:SetHealth(1)
			ent:SetMaxHealth(1)
		else
			ent:SetHealth(math.ceil(ent:Health() * 3))
			ent:SetMaxHealth(ent:Health())
		end
	end

	local findent = ents.FindByClass("func_physbox")
	findent = table.Add(findent, ents.FindByClass("func_breakable"))
	for _, ent in pairs(findent) do
		local aa, bb = ent:WorldSpaceAABB()

		if 40 <= math.abs(aa.z - bb.z) then ent.AllowDamage = true end
	end
end

function GM:PlayerSelectSpawn(pl)
	if pl:Team() == TEAM_UNDEAD then
		local Count = #self.UndeadSpawnPoints
		if Count == 0 then return pl end
		for i=0, 20 do
			local ChosenSpawnPoint = self.UndeadSpawnPoints[math.random(1, Count)]
			if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint ~= LastZombieSpawnPoint and not ChosenSpawnPoint.Disabled and ChosenSpawnPoint:IsInWorld() then
				local blocked = false
				for _, ent in pairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-20, -20, 0), ChosenSpawnPoint:GetPos() + Vector(20, 20, 74))) do
					if ent:IsPlayer() or string.find(ent:GetClass(), "prop_") then
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
			if ChosenSpawnPoint and ChosenSpawnPoint:IsValid() and ChosenSpawnPoint ~= LastHumanSpawnPoint and not ChosenSpawnPoint.Disabled and ChosenSpawnPoint:IsInWorld() then
				local blocked = false
				for _, ent in pairs(ents.FindInBox(ChosenSpawnPoint:GetPos() + Vector(-20, -20, 0), ChosenSpawnPoint:GetPos() + Vector(20, 20, 74))) do
					if ent:IsPlayer() or string.find(ent:GetClass(), "prop_") then
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
		umsg.Short(self:GetWave())
	umsg.End()
end

function GM:AmmoRegenerate()
	if self:GetWave() == 0 then return end

	local plays = player.GetAll()
	if 0.75 <= INFLICTION then plays = table.Add(plays, player.GetAll()) end -- Double ammo on horde conditions

	for _, pl in pairs(plays) do
		if pl:Team() == TEAM_HUMAN then
			local wep = pl:GetActiveWeapon()
			if wep:IsValid() and wep:IsWeapon() then
				local typ = string.lower(wep:GetPrimaryAmmoTypeString())
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

local NextAmmoDropOff = AMMO_REGENERATE_RATE
local nextzombiedecay = 0
function GM:Think()
	local tim = CurTime()

	if self.Fighting then
		if self.WaveEnd <= tim then
			self:SetFighting(false)
		end
	elseif self.WaveStart <= tim then
		self:SetFighting(true)
	end

	if NextAmmoDropOff < tim then
		NextAmmoDropOff = tim + AMMO_REGENERATE_RATE

		self:AmmoRegenerate()
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
	local humans = 0
	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == TEAM_UNDEAD then
			zombies = zombies + 1
		else
			humans = humans + 1
		end
		players = players + 1
	end
	INFLICTION = math.max(math.Clamp(zombies / players, 0.001, 1), CAPPED_INFLICTION)
	CAPPED_INFLICTION = INFLICTION

	if humans == 1 and 2 < zombies then
		self:LastHuman()
	elseif 1 <= INFLICTION then
		self:EndRound(TEAM_UNDEAD)
		return
	elseif 0.75 <= INFLICTION then
		UNLIFE = true
		HALFLIFE = true
	elseif 0.5 <= INFLICTION then
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
		return b.SurvivalTime < a.SurvivalTime
	end)

	local x = 0
	for _, pl in pairs(PlayerSorted) do
		if x < 5 then
			x = x + 1
			umsg.Start("RcTopTimes", to)
				umsg.Short(x)
				umsg.String(pl:Name()..": "..string.ToMinutesSeconds(pl.SurvivalTime))
			umsg.End()
		end
	end
end

function GM:SendTopZombies(to)
	local PlayerSorted = {}

	for k, v in pairs(player.GetAll()) do
		if v.BrainsEaten and 0 < v.BrainsEaten then
			table.insert(PlayerSorted, v)
		end
	end

	if #PlayerSorted <= 0 then return end -- Don't bother sending it, the cleint gamemode won't display anything.
	table.sort(PlayerSorted,
	function(a, b)
		if a.BrainsEaten == b.BrainsEaten then
			return a:Deaths() < b:Deaths()
		end
		return b.BrainsEaten < a.BrainsEaten
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
		if pl.DamageDealt and pl.DamageDealt[TEAM_HUMAN] and 0 < pl.DamageDealt[TEAM_HUMAN] then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_HUMAN] == b.DamageDealt[TEAM_HUMAN] then
			return b:UserID() < a:UserID()
		end
		return b.DamageDealt[TEAM_HUMAN] < a.DamageDealt[TEAM_HUMAN]
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
		if pl.DamageDealt and pl.DamageDealt[TEAM_UNDEAD] and 0 < pl.DamageDealt[TEAM_UNDEAD] then
			table.insert(PlayerSorted, pl)
		end
	end

	if #PlayerSorted <= 0 then return end
	table.sort(PlayerSorted,
	function(a, b)
		if a.DamageDealt[TEAM_UNDEAD] == b.DamageDealt[TEAM_UNDEAD] then
			return b:UserID() < a:UserID()
		end
		return b.DamageDealt[TEAM_UNDEAD] < a.DamageDealt[TEAM_UNDEAD]
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
	self.Think = function(gam) end
	ENDROUND = true
	timer.Simple(INTERMISSION_TIME, game.LoadNextMap)
	timer.Simple(INTERMISSION_TIME + 10, RunConsoleCommand, "changelevel", "zs_nastyhouse")
	timer.Simple(INTERMISSION_TIME * 0.4, gmod.BroadcastLua, "OpenVoteMenu()")
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

	self.PlayerDeathThink = function(gam, pla)
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
		pl:SprintDisable()
		pl:SetCanWalk(false)
		pl:SendLua("MySelf:SetZombieClass("..pl.Class..") SURVIVALMODE="..tostring(SURVIVALMODE))
		self:SendInflictionInit(pl)
		self:FullGameUpdate(pl)
	end
end

function GM:FullGameUpdate(pl)
	umsg.Start("reczsgamestate", pl)
		umsg.Short(self:GetWave())
		umsg.Short(self:GetWaveStart())
		umsg.Short(self:GetWaveEnd())
	umsg.End()
end

concommand.Add("PostPlayerInitialSpawn", function(sender, command, arguments)
	if not sender.PostPlayerInitialSpawn then
		sender.PostPlayerInitialSpawn = true

		gamemode.Call("PlayerReady", sender)
	end
end)

function GM:PlayerInitialSpawn(pl)
	pl:SprintDisable()
	pl:SetCanZoom(false)
	pl.NextSpawnTime = 0
	pl:SetCanWalk(false)
	--pl:SetJumpPower(160)
	pl:SetZombieClass(1)
	pl.Gibbed = false
	pl.BrainsEaten = 0
	pl.WaveJoined = self:GetWave()
	pl.NextShove = 0
	pl.NextHold = 0
	pl.ZombiesKilled = 0
	pl.NextPainSound = 0
	pl.ZomAnim = 2
	pl.HighestAmmoType = "pistol"
	pl.DamageDealt = {}
	pl.DamageDealt[TEAM_UNDEAD] = 0
	pl.DamageDealt[TEAM_HUMAN] = 0

	if DeadSteamIDs[pl:SteamID()] then
		pl:SetTeam(TEAM_UNDEAD)
	elseif self:GetWave() <= 0 then
		pl.SpawnedTime = CurTime()
		pl:SetTeam(TEAM_HUMAN)
	elseif team.NumPlayers(TEAM_UNDEAD) < 1 and 2 < team.NumPlayers(TEAM_HUMAN) then
		if self:SetRandomToZombie() ~= pl then
			pl.SpawnedTime = CurTime()
			pl:SetTeam(TEAM_HUMAN)
		end
	elseif NONEWJOIN_WAVE <= self:GetWave() then
		pl:SetTeam(TEAM_UNDEAD)
		DeadSteamIDs[pl:SteamID()] = true
	else
		pl.SpawnedTime = CurTime()
		pl:SetTeam(TEAM_HUMAN)
	end
	self:CalculateInfliction()
end

function GM:CheckPlayerScore(pl)
	local score = pl:Frags()
	if self.Rewards[score] then
		local reward = self.Rewards[score][math.random(1, #self.Rewards[score])]
		if string.sub(reward, 1, 1) == "_" then
			PowerupFunctions[reward](pl)
		elseif pl:HasWeapon(reward) then // They picked the weapon up from a dead teamate.
			local hasall = true
			for _, anotherwep in pairs(self.Rewards[score]) do
				if not pl:HasWeapon(anotherwep) then
					pl:Give(anotherwep)
					local wep = pl:GetWeapon(anotherwep)
					if wep:IsValid() then
						pl.HighestAmmoType = string.lower(wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType)
					end
					hasall = false
					break
				end
			end
			if hasall then
				local wep = pl:GetWeapon(reward)
				if wep:IsValid() then
					local ammotype = string.lower(wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType or "pistol")
					pl:GiveAmmo(self.AmmoRegeneration[ammotype], ammotype, true)
				end
			end
		else
			pl:Give(reward)
			local wep = pl:GetWeapon(reward)
			if wep:IsValid() then
				pl.HighestAmmoType = string.lower(wep:GetPrimaryAmmoTypeString() or pl.HighestAmmoType)
			end
		end
	end
end

function GM:PlayerNoClip(pl, on)
	if pl:IsAdmin() and ALLOW_ADMIN_NOCLIP then
		return true
	end

	return false
end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
	return true
end

function GM:OnPhysgunReload(weapon, pl)
end

function GM:PlayerDisconnected(pl)
	pl.Discon = true
	self:GetLivingZombies()
	timer.Simple(2, self.CalculateInfliction, self)

	local steamid = pl:SteamID()
	DeadSteamIDs[steamid] = true
end

function GM:PlayerDeathThink(pl)
	if pl.StartSpectating then
		if pl.StartSpectating <= CurTime() then
			pl.StartSpectating = nil
			pl:SetHealth(100)
			pl:Spectate(OBS_MODE_ROAMING)
		end
	elseif pl.NextSpawnTime <= CurTime() then
		if pl:Team() == TEAM_UNDEAD then
			if pl:KeyDown(IN_ATTACK) and CurTime() <= self.WaveEnd then
				pl:Spawn()
			end
		else
			pl:Spawn()
		end
	end
end

util.PrecacheSound("physics/metal/metal_box_impact_bullet1.wav")
util.PrecacheSound("physics/metal/metal_box_impact_bullet2.wav")
util.PrecacheSound("physics/metal/metal_box_impact_bullet3.wav")

function GM:EntityTakeDamage(ent, attacker, inflictor, damage)
	if ent.SendLua then return end

	if ent.Nails and not (attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetActiveWeapon().IsMelee) then
		for i=1, #ent.Nails do
			local nail = ent.Nails[i]
			if nail then
				if nail:IsValid() then
					nail.Heal = nail.Heal - damage
					ent:SetHealth(ent:Health() + damage)
					if nail.Heal <= 0 then
						local findcons = nail.constraint
						local numcons = 0
						for _, theent in pairs(ents.FindByClass("nail")) do
							if theent.constraint == findcons then numcons = numcons + 1 end
						end
						if numcons == 1 then
							findcons:Remove()
						else
							nail:Remove()
						end
						table.remove(ent.Nails, i)
						if #ent.Nails <= 0 then
							ent.Nails = nil
						end
					end
					return
				else
					table.remove(ent.Nails, i)
					i = i - 1
				end
			end
		end
	end

	local entclass = ent:GetClass()
	if ent.PropHealth then
		local holder, status = ent:GetHolder()
		if holder then status:Remove() end

		if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetActiveWeapon().IsMelee then return end

		ent.PropHealth = ent.PropHealth - damage

		if ent.PropHealth <= 0 then
			local effectdata = EffectData()
				effectdata:SetOrigin(ent:GetPos())
			util.Effect("Explosion", effectdata, true, true)
			ent:Fire("break")
		else
			local brit = math.Clamp(ent.PropHealth / ent.TotalHealth, 0, 1)
			local r,g,b,a = ent:GetColor()
			ent:SetColor(255, 255 * brit, 255 * brit, a)
		end
	elseif entclass == "prop_door_rotating" then
		ent.Heal = ent.Heal or ent:BoundingRadius() * 35
		ent.TotalHeal = ent.TotalHeal or ent.Heal

		if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetActiveWeapon().IsMelee then return end

		ent.Heal = ent.Heal - damage
		local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
		local r,g,b,a = ent:GetColor()
		ent:SetColor(255, 255 * brit, 255 * brit, a)

		if ent.Heal <= 0 then
			local physprop = ents.Create("prop_physics_multiplayer")
			if physprop:IsValid() then
				physprop:SetPos(ent:GetPos())
				physprop:SetAngles(ent:GetAngles())
				physprop:SetSkin(ent:GetSkin())
				physprop:SetMaterial(ent:GetMaterial())
				physprop:SetModel(ent:GetModel())
				physprop:Spawn()
				ent:Fire("break")
				physprop:SetPhysicsAttacker(attacker)
				local phys = physprop:GetPhysicsObject()
				if phys:IsValid() then
					if attacker:IsValid() then
						phys:SetVelocityInstantaneous((physprop:NearestPoint(attacker:EyePos()) - attacker:EyePos()):Normalize() * math.Clamp(damage * 3, 40, 300))
					end
				end
			end
		end
	elseif entclass == "func_physbox" then
		local holder, status = ent:GetHolder()
		if holder then status:Remove() end
		ent.Heal = ent.Heal or ent:BoundingRadius() * 35
		ent.TotalHeal = ent.TotalHeal or ent.Heal

		if not ent.AllowDamage and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetActiveWeapon().IsMelee then return end

		ent.Heal = ent.Heal - damage
		local brit = math.Clamp(ent.Heal / ent.TotalHeal, 0, 1)
		local r,g,b,a = ent:GetColor()
		ent:SetColor(255, 255 * brit, 255 * brit, a)

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
		if not ent.AllowDamage and attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetActiveWeapon().IsMelee and 40 <= ent:GetMaxHealth() then ent:SetHealth(ent:Health()+damage) return end

		local brit = math.Clamp(ent:Health() / ent:GetMaxHealth(), 0, 1)
		local r,g,b,a = ent:GetColor()
		ent:SetColor(255, 255 * brit, 255 * brit, a)
	elseif string.find(entclass, "prop_physics") then
		if attacker:IsPlayer() and attacker:Team() == TEAM_HUMAN and attacker:GetActiveWeapon().IsMelee and 40 <= ent:GetMaxHealth() then ent:SetHealth(ent:Health()+damage) return end

		local holder, status = ent:GetHolder()
		if holder then status:Remove() end
	end
end

function GM:SetRandomToZombie()
	local plays = player.GetAll()
	local newpl = plays[math.random(1, #plays)]
	newpl:SetTeam(TEAM_UNDEAD)
	DeadSteamIDs[newpl:SteamID()] = true
	newpl:StripWeapons()
	newpl:Spawn()
	umsg.Start("recranfirstzom", newpl)
	umsg.End()

	return newpl
end

function GM:SetRandomsToZombie()
	local allplayers = player.GetAll()
	local numplayers = #allplayers

	if numplayers <= 1 then return end

	local desiredzombies = math.max(1, math.ceil(numplayers * WAVE_ONE_ZOMBIES))

	local vols = 0
	local voltab = {}
	for _, gasses in pairs(ents.FindByClass("zombiegasses")) do
		for _, ent in pairs(ents.FindInSphere(gasses:GetPos(), 256)) do
			if ent:IsPlayer() and not table.HasValue(voltab, ent) then
				vols = vols + 1
				table.insert(voltab, ent)
			end
		end
	end

	for _, pl in pairs(allplayers) do
		if pl:Team() == TEAM_UNDEAD then
			vols = vols + 1
			table.insert(voltab, pl)
		end
	end

	if vols == desiredzombies then
		for _, pl in pairs(voltab) do
			pl:SetTeam(TEAM_UNDEAD)
			DeadSteamIDs[pl:SteamID()] = true
			pl:StripWeapons()
			pl:Spawn()
			umsg.Start("recvolfirstzom", pl)
			umsg.End()
		end
	elseif vols < desiredzombies then
		local spawned = 0
		for i, pl in ipairs(voltab) do
			pl:SetTeam(TEAM_UNDEAD)
			DeadSteamIDs[pl:SteamID()] = true
			pl:StripWeapons()
			pl:Spawn()
			umsg.Start("recvolfirstzom", pl)
			umsg.End()
			spawned = i
		end

		for i = 1, desiredzombies - spawned do
			local humans = team.GetPlayers(TEAM_HUMAN)

			if 0 < #humans then
				local pl = humans[math.random(1, #humans)]
				pl:SetTeam(TEAM_UNDEAD)
				DeadSteamIDs[pl:SteamID()] = true
				pl:StripWeapons()
				pl:Spawn()
				umsg.Start("recranfirstzom", pl)
				umsg.End()
			end
		end
	elseif desiredzombies < vols then
		for i, pl in ipairs(voltab) do
			if desiredzombies < i and pl:Team() == TEAM_HUMAN then
				pl:SetPos(self:PlayerSelectSpawn(pl):GetPos())
			else
				pl:SetTeam(TEAM_UNDEAD)
				DeadSteamIDs[pl:SteamID()] = true
				pl:StripWeapons()
				pl:Spawn()
				umsg.Start("recvolfirstzom", pl)
				umsg.End()
			end
		end
	end
end

function GM:PlayerShouldTakeDamage(pl, attacker)
	if attacker.Nails and 0 < #attacker.Nails then
		return false
	elseif attacker.SendLua then
		if attacker:Team() == pl:Team() then
			return attacker == pl
		end
		pl.LastAttacker = attacker
	elseif attacker.TeamID then
		return attacker.TeamID ~= pl:Team()
	end
	return true
end

function GM:PlayerHurt(victim, attacker, healthremaining, damage)
	if 0 < healthremaining then
		victim:PlayPainSound()
	end

	if attacker.SendLua then
		local myteam = attacker:Team()
		if myteam ~= victim:Team() then
			attacker.DamageDealt[myteam] = attacker.DamageDealt[myteam] + damage
		end
	end
end

function GM:WeaponDeployed(owner, wep, ironsights)
	local timername = tostring(owner).."speedchange"
	timer.Destroy(timername)

	local speed = wep.WalkSpeed or 200
	if owner:GetNetworkedBool("IsHolding") then
		for _, status in pairs(ents.FindByClass("status_human_holding")) do
			if status:GetOwner() == owner and status.Object:IsValid() and status.Object:GetPhysicsObject():IsValid() then
				speed = math.max(CARRY_SPEEDLOSS_MINSPEED, speed - status.Object:GetPhysicsObject():GetMass() * CARRY_SPEEDLOSS_PERKG)
				break
			end
		end
	elseif ironsights then
		speed = math.min(speed, 94)
	end

	if speed < owner.WalkSpeed then
		self:SetPlayerSpeed(owner, speed)
	elseif owner.WalkSpeed < speed then
		timer.Create(timername, 0.25, 1, self.SetPlayerSpeed, self, owner, speed)
	end
end

local weaponmodelstoweapon = {}
weaponmodelstoweapon["models/props/cs_office/computer_keyboard.mdl"] = "weapon_zs_keyboard"
weaponmodelstoweapon["models/props_c17/computer01_keyboard.mdl"] = "weapon_zs_keyboard"
weaponmodelstoweapon["models/props_c17/metalpot001a.mdl"] = "weapon_zs_pot"
weaponmodelstoweapon["models/props_interiors/pot02a.mdl"] = "weapon_zs_fryingpan"
weaponmodelstoweapon["models/props_junk/shovel01a.mdl"] = "weapon_zs_shovel"
weaponmodelstoweapon["models/props/cs_militia/axe.mdl"] = "weapon_zs_axe"
weaponmodelstoweapon["models/props_c17/tools_wrench01a.mdl"] = "weapon_zs_hammer"

function GM:PlayerUse(pl, entity)
	if not pl:Alive() then return false end

	if entity.ToWeapon and not pl:HasWeapon(entity.ToWeapon) and pl:Alive() and pl:Team() ~= TEAM_UNDEAD then
		local ent = ents.Create(entity.ToWeapon)
		if ent:IsValid() then
			ent:SetPos(pl:GetPos())
			if ent.Primary then
				ent.Primary.DefaultClip = 0
			end
			if ent.Secondary then
				ent.Secondary.DefaultClip = 0
			end
			ent:Spawn()

			local ww = pl:GetWeapon(entity.ToWeapon)
			if ww and ww:IsValid() then
				if ww.Primary and ww.Primary.Ammo then
					pl:GiveAmmo(ww:Clip1(), ww.Primary.Ammo)
					ww:SetClip1(0)
				end
				--[[if ww.Secondary and ww.Secondary.Ammo then
					pl:GiveAmmo(ww:Clip2(), ww.Secondary.Ammo)
					ww:SetClip2(0)
				end]]
			end

			entity:Remove()
		end
		return
	end

	local mdl = string.lower(entity:GetModel() or "")
	local wep = weaponmodelstoweapon[mdl]
	local entclass = entity:GetClass()
	if entclass == "prop_door_rotating" then
		if entity.AntiDoorSpam < CurTime() then
			entity.AntiDoorSpam = CurTime() + 0.85
			return true
		else
			return false
		end
	elseif string.find(entclass, "prop_physics") and wep and not pl:HasWeapon(wep) then
		pl:Give(wep)
		entity:Remove()
		return false
	elseif (string.find(entclass, "prop_physics") or entclass == "func_physbox") and pl:Team() == TEAM_HUMAN and not entity.Nails and pl:Alive() and entity:GetMoveType() == MOVETYPE_VPHYSICS and entity:GetPhysicsObject():GetMass() <= CARRY_MAXIMUM_MASS and entity:GetPhysicsObject():IsMoveable() and entity:OBBMins():Length() + entity:OBBMaxs():Length() <= CARRY_MAXIMUM_VOLUME then
		local holder, status = entity:GetHolder()
		if holder == pl and pl.NextUnHold < CurTime() then
			status:Remove()
			pl.NextHold = CurTime() + 0.5
		elseif not holder and not pl:GetNetworkedBool("IsHolding") and pl.NextHold < CurTime() and pl:GetShootPos():Distance(entity:NearestPoint(pl:GetShootPos())) < 64 and pl:GetGroundEntity() ~= entity then
			local newstatus = ents.Create("status_human_holding")
			if newstatus:IsValid() then
				pl.NextHold = CurTime() + 1.5
				pl.NextUnHold = CurTime() + 0.5
				newstatus:SetPos(pl:GetShootPos())
				newstatus:SetOwner(pl)
				newstatus:SetParent(pl)
				newstatus.Object = entity
				newstatus:Spawn()
				self:SetPlayerSpeed(pl, math.max(CARRY_SPEEDLOSS_MINSPEED, 200 - entity:GetPhysicsObject():GetMass() * CARRY_SPEEDLOSS_PERKG))
			end
		end
	end

	return true
end

function SecondWind(pl)
	if pl and pl:IsPlayer() then
		if pl.Gibbed or pl:Alive() or pl:Team() ~= TEAM_UNDEAD then return end
		local pos = pl:GetPos()
		local angles = pl:EyeAngles()
		local lastattacker = pl.LastAttacker
		local dclass = pl.DeathClass
		pl.DeathClass = nil
		pl.Revived = true
		pl:Spawn()
		pl.Revived = nil
		pl.DeathClass = dclass
		pl.LastAttacker = lastattacker
		DeSpawnProtection(pl)
		pl:SetPos(pos)
		pl:SetHealth(pl:Health() * 0.2)
		pl:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav", 100, 85)
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
	if pl:Team() == TEAM_HUMAN and self:GetWave() <= NOSUICIDE_WAVE then
		pl:PrintMessage(HUD_PRINTCENTER, "Give others time to spawn before suiciding.")
		return false
	end

	return pl:GetMoveType() ~= MOVETYPE_OBSERVER and pl:Alive() and (not pl.SpawnNoSuicide or pl.SpawnNoSuicide < CurTime())
end

local function ChemBomb(pl, refrag)
	local effectdata = EffectData()
		effectdata:SetOrigin(pl:GetPos())
	util.Effect("chemzombieexplode", effectdata, true)
	util.BlastDamage(pl, pl, pl:GetPos() + Vector(0,0,16), 170, 65)
	if refrag then
		pl:AddFrags(100)
	end
	if REDEEM and AUTOREDEEM then
		if REDEEM_KILLS <= pl:Frags() then
			pl:Redeem()
			timer.Destroy("Survivalist")
		end
	end
end

--[[concommand.Add("setbury", function(sender, command, arguments)
	if sender:Team() == TEAM_UNDEAD and sender:GetMoveType() == MOVETYPE_OBSERVER and not GAMEMODE:GetFighting() and not ENDROUND then
		local tr = sender:TraceLine(10000)
		if not tr.HitWorld then sender:PrintMessage(HUD_PRINTCENTER, "Can not spawn on a non-solid surface.") return end
		if not tr.HitNormal.z < 0.8 then sender:PrintMessage(HUD_PRINTCENTER, "Can only spawn on flat areas.") return end

		local burytr = util.TraceLine({start=tr.HitPos + tr.HitNormal * -8, endpos=tr.HitPos + tr.HitNormal * 12, mask=MASK_SOLID_BRUSHONLY})
		if not burytr.HitWorld then
			sender.BuryPos = tr.HitPos + tr.HitNormal * 8
			sender:PrintMessage(HUD_PRINTCENTER, "You will spawn here when the wave begins.")
			return
		end

		local burytr = util.TraceLine({start=tr.HitPos + tr.HitNormal * -16, endpos=tr.HitPos + tr.HitNormal * -24, mask=MASK_SOLID_BRUSHONLY})
		if burytr.Fraction == 0 then
			sender.BuryPos = tr.HitPos + tr.HitNormal * 8
			sender:PrintMessage(HUD_PRINTCENTER, "You will spawn here when the wave begins.")
		else
			sender:PrintMessage(HUD_PRINTCENTER, "The ground is not solid enough for you to spawn there.")
		end

		if not tr.HitNormal.z < 0.8 then sender:PrintMessage(HUD_PRINTCENTER, "Can only spawn in flat areas.") return end
	end
end)]]

function DefaultRevive(pl)
	timer.Create(pl:UniqueID().."secondwind", 2, 1, SecondWind, pl)
	pl:GiveStatus("revive", 3.5)
end

function GM:DoPlayerDeath(pl, attacker, dmginfo)
	pl:SetLocalVelocity(pl:GetVelocity() * 2.5)

	pl:Freeze(false)

	self:GetLivingZombies()

	local headshot
	if dmginfo:IsBulletDamage() then
		local attach = pl:GetAttachment(1)
		headshot = attach and dmginfo:GetDamagePosition():Distance(attach.Pos) < 14
	end

	local revive = false
	local inflictor = NULL
	local suicide = false

	local plteam = pl:Team()

	if (attacker == pl or attacker:IsWorld()) and pl.LastAttacker and pl.LastAttacker:IsValid() and pl.LastAttacker:Team() ~= plteam then
		attacker = pl.LastAttacker
		inflictor = attacker:GetActiveWeapon()
		suicide = true
	elseif attacker and attacker:IsValid() then
		if attacker:IsPlayer() then
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

	local ct = CurTime()

	pl.NextSpawnTime = ct + 4
	pl:AddDeaths(1)
	if plteam == TEAM_UNDEAD and pl.ClassTable.Name == "Chem-Zombie" and attacker ~= pl and not suicide then
		pl:Gib(dmginfo)
		pl.Gibbed = true
		if LASTHUMAN then
			timer.Simple(0, ChemBomb, pl, false)
		else
			pl:AddFrags(-100) -- Designed to make it so a person doesn't kill 4 people, redeem, and then any other humans near the blast won't take damage and any zombies nearby will.
			timer.Simple(0, ChemBomb, pl, true)
		end
	elseif pl:Health() < -45 or dmginfo:IsExplosionDamage() or dmginfo:IsFallDamage() then
		pl:Gib(dmginfo)
		pl.Gibbed = true
	elseif not pl.KnockedDown then
		pl:CreateRagdoll()
	end

	if plteam == TEAM_UNDEAD then
		if attacker:IsValid() and attacker:IsPlayer() and attacker ~= pl then
			if pl.ClassTable.Revives and not pl.Gibbed and not headshot then
				if pl.ClassTable.ReviveCallback then
					revive = pl.ClassTable.ReviveCallback(pl, attacker, dmginfo)
				elseif math.random(1, 4) ~= 1 then -- Default 75% chance to revive.
					DefaultRevive(pl)
					revive = true
				end
			end

			if not revive then
				attacker:AddFrags(1)

				pl:PlayZombieDeathSound()
				self:CheckPlayerScore(attacker)
				UNDEADSLAIN = UNDEADSLAIN + 1
				if self.WaveEnd <= ct then
					pl.StartSpectating = ct + 3
				end
			end
		else
			pl:PlayZombieDeathSound()
		end
	else
		if attacker:IsPlayer() and attacker ~= pl then
			attacker:AddFrags(1)
			attacker.BrainsEaten = attacker.BrainsEaten + 1
			BRAINSEATEN = BRAINSEATEN + 1
			if REDEEM and AUTOREDEEM then
				if REDEEM_KILLS <= attacker:Frags() or INFINITEREDEEMS then
					if INFINITEREDEEMS then
						gmod.BroadcastLua([[InfRed("]]..attacker:Name()..[[")]])
					end
					attacker:Redeem()
					timer.Destroy("Survivalist")
				end
			end
			if not pl.Gibbed and not suicide then
				timer.Create(pl:UniqueID().."secondwind", 2.5, 1, SecondWind, pl)
				pl:PlayDeathSound()
				pl:GiveStatus("revive2", 3.5)
			end
		end
		if WARMUP_MODE and #player.GetAll() < WARMUP_THRESHOLD then
			pl:PrintMessage(HUD_PRINTTALK, "There are not enough people playing for you to change to the Undead. Set WARMUP_MODE in zs_options.lua to false to change this.")
		else
			timer.Simple(0, pl.SetTeam, pl, TEAM_UNDEAD) -- We don't want people shooting barrels near teammates.
			DeadSteamIDs[pl:SteamID()] = true
		end
		--pl:SendLua("Died()")
		pl:SetFrags(0)
		if pl.SpawnedTime then
			local survtime = CurTime() - pl.SpawnedTime
			if pl.SurvivalTime then
				if pl.SurvivalTime < survtime then
					pl.SurvivalTime = survtime
				end
			else
				pl.SurvivalTime = CurTime() - pl.SpawnedTime
			end
		end
		pl.SpawnedTime = nil
		timer.Create("DelayedCalculate", 0.2, 1, self.CalculateInfliction, self) -- Make sure that chem-zombies who blow up a lot of people at the end don't redeem and still lose.
	end

	if revive then return end

	if attacker == pl then
		umsg.Start("PlayerKilledSelf")
			umsg.Entity(pl)
			umsg.Short(plteam)
		umsg.End()
	elseif attacker:IsPlayer() then
		if headshot then
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
			umsg.Short(plteam)
			umsg.Short(attacker:Team())
			umsg.Bool(headshot)
		umsg.End()
	else
		umsg.Start("PlayerKilled")
			umsg.Entity(pl)
			umsg.String(inflictor:GetClass())
			umsg.String(attacker:GetClass())
			umsg.Short(plteam)
		umsg.End()
	end
end

function GM:PlayerCanPickupWeapon(ply, entity)
	if ply:Team() == TEAM_UNDEAD then return entity:GetClass() == ply.ClassTable.SWEP end

	return not entity.ZombieOnly and entity:GetClass() ~= "weapon_stunstick"
end

function SpawnProtection(pl, tim)
	local ent = ents.Create("status_spawnprotection")
	if ent:IsValid() then
		ent:SetPos(pl:GetPos() + Vector(0,0,16))
		pl["status_spawnprotection"] = ent
		ent:SetOwner(pl)
		ent:SetParent(pl)
		ent:Spawn()
		ent.DieTime = CurTime() + tim
	end
	GAMEMODE:SetPlayerSpeed(pl, GAMEMODE.ZombieClasses[pl:GetZombieClass()].Speed * 1.5)
	pl:GodEnable()
end

function DeSpawnProtection(pl)
	if pl:IsValid() and pl:IsPlayer() then
		GAMEMODE:SetPlayerSpeed(pl, GAMEMODE.ZombieClasses[pl.Class].Speed)
		pl:GodDisable()
	end
end

concommand.Add("zsdropweapon", function(sender, command, arguments)
	if not (sender:IsValid() and sender:Alive() and sender:Team() == TEAM_HUMAN) then return end

	sender.NextWeaponDrop = sender.NextWeaponDrop or 0
	if sender.NextWeaponDrop < CurTime() then
		sender.NextWeaponDrop = CurTime() + 1

		-- Custom code so people have to press +USE to pick it up and we can make some effects.

		local wep = sender:GetActiveWeapon()
		if wep:IsValid() then
			local class = wep:GetClass()
			local ent = ents.Create("prop_physics_multiplayer")
			if ent:IsValid() then
				if wep.Primary and wep.Primary.Ammo then
					sender:GiveAmmo(wep:Clip1(), wep.Primary.Ammo, true)
					wep:SetClip1(0)
				end
				if wep.Secondary and wep.Secondary.Ammo then
					sender:GiveAmmo(wep:Clip2(), wep.Secondary.Ammo, true)
					wep:SetClip2(0)
				end

				local shootpos = sender:GetShootPos()
				local aimvec = sender:GetAimVector()
				ent:SetPos(util.TraceLine({start=shootpos, endpos=shootpos + aimvec * 32, mask=MASK_SOLID, filter=sender}).HitPos)
				ent:SetAngles(sender:GetAngles())
				ent:SetModel(wep.WorldModel)
				ent:Spawn()
				ent:SetCollisionGroup(COLLISION_GROUP_WEAPON)
				ent.ToWeapon = class

				sender:StripWeapon(class)
			end
		end
	end
end)

concommand.Add("zsemptyclip", function(sender, command, arguments)
	if not (sender:IsValid() and sender:Alive() and sender:Team() == TEAM_HUMAN) then return end

	sender.NextEmptyClip = sender.NextEmptyClip or 0
	if sender.NextEmptyClip < CurTime() then
		sender.NextEmptyClip = CurTime() + 1

		local wep = sender:GetActiveWeapon()

		if wep.Primary.Ammo and wep.Primary.Ammo ~= "none" and 0 < wep:Clip1() then
			sender:GiveAmmo(wep:Clip1(), wep.Primary.Ammo, true)
			wep:SetClip1(0)
		end
	end
end)

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
	pl:StripWeapons()
	pl:SetColor(255, 255, 255, 255)
	pl:SetMaterial("")
	pl.StartSpectating = nil
	pl.Gibbed = nil
	timer.Destroy(pl:UserID().."SpawnProtection")

	pl.SpawnNoSuicide = CurTime() + 1.5

	local plteam = pl:Team()
	pl:ShouldDropWeapon(plteam == TEAM_HUMAN)

	--pl:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	if plteam == TEAM_UNDEAD then
		if pl.DeathClass then
			pl:SetZombieClass(pl.DeathClass)
			pl.DeathClass = nil
		end
		local class = pl:GetZombieClass()
		local classtab = pl.ClassTable
		pl:SetModel(classtab.Model)
		if 1 < team.NumPlayers(TEAM_UNDEAD) then
			pl:SetHealth(classtab.Health)
		else
			pl:SetHealth(classtab.Health * 2)
		end

		if classtab.SWEP then
			pl:Give(classtab.SWEP)
		end

		if pl.Revived or self:GetFighting() and CurTime() < self:GetWaveEnd() then
			self:SetPlayerSpeed(pl, classtab.Speed)
			pl:SetCrouchedWalkSpeed(classtab.CrouchedWalkSpeed or 0.70)
			--pl.PlayerFootstep = classtab.PlayerFootstep ~= nil
			pl:SetNoTarget(true)
			pl:SetMaxHealth(1) -- To prevent picking up health packs
			if not pl.Revived and INFLICTION < 0.5 then
				SpawnProtection(pl, 5 - INFLICTION * 5) -- Less infliction, more spawn protection.
			end
			if pl.BuryPos then
				pl:SetPos(pl.BuryPos)
				pl.BuryPos = nil
			end
		else
			pl:Spectate(OBS_MODE_ROAMING)
			--pl:KillSilent()
		end
	else
		--pl.PlayerFootstep = nil
		local modelname = string.lower(player_manager.TranslatePlayerModel(pl:GetInfo("cl_playermodel")))
		if self.RestrictedModels[modelname] then
			modelname = "models/player/alyx.mdl"
		end

		pl:SetModel(modelname)

		pl.VoiceSet = VoiceSetTranslate[modelname] or "male"

		self:SetPlayerSpeed(pl, 200)
		pl:SetCrouchedWalkSpeed(0.65)

		if self.STARTLOADOUTS[1] then
			for _, wep in pairs(self.STARTLOADOUTS[math.random(1, #self.STARTLOADOUTS)]) do
				pl:Give(wep)
			end
		end

		pl:SetNoTarget(false)
		pl:SetMaxHealth(100)
	end

	self:GetLivingZombies()

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
	if pl:Team() == TEAM_UNDEAD then
		if hitgroup == HITGROUP_HEAD then
			dmginfo:ScaleDamage(2)
		else
			dmginfo:ScaleDamage(0.75)
		end
		dmginfo:ScaleDamage(1 - math.min(GetZombieFocus(pl:GetPos(), FOCUS_RANGE, 0.001, 0) - 0.3, 0.75))
	end

	return dmginfo
end

function GM:PlayerSwitchFlashlight(pl, switchon)
	if switchon then return pl:Alive() and pl:Team() == TEAM_HUMAN end

	return true
end

function ThrowHeadcrab(owner, wep)
	if not owner:IsValid() then return end
	if not owner:IsPlayer() then return end
	if not wep.Weapon then return end
	if owner:Alive() and owner:Team() == TEAM_UNDEAD and owner.Class == 3 then
		wep.Weapon:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		GAMEMODE:SetPlayerSpeed(owner, GAMEMODE.ZombieClasses[3].Speed)
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

	if GAMEMODE.ZombieClasses[arguments] then
		local classtab = GAMEMODE.ZombieClasses[arguments]
		if classtab.Hidden then
			sender:SendLua("GAMEMODE:SplitMessage(h*0.65,\"<color=ltred><font=HUDFontAA>AND STOP SHOUTING! I'M NOT DEAF!</font></color>\")")
		elseif not classtab.Unlocked and GAMEMODE:GetWave() < classtab.Wave and not (not GAMEMODE:GetFighting() and classtab.Wave <= GAMEMODE:GetWave() + 1) then
			sender:SendLua("GAMEMODE:SplitMessage(h*0.65,\"<color=ltred><font=HUDFontAA>That class is not unlocked yet. It will be unlocked at wave "..classtab.Wave.."</font></color>\")")
		elseif sender.ClassTable.Name == arguments and not sender.DeathClass then
			sender:SendLua("GAMEMODE:SplitMessage(h*0.65,\"<color=ltred><font=HUDFontAA>You are already a "..classtab.Name.."!</font></color>\")")
		else
			sender:SendLua("GAMEMODE:SplitMessage(h*0.65,\"<color=ltred><font=HUDFontAA>You will spawn as a "..classtab.Name..".</font></color>\")")
			sender.DeathClass = GAMEMODE.ZombieClasses[arguments].Index
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

	if damage < ent:Health() then
		ent:SetHealth(ent:Health() - damage)
		ent:EmitSound("player/pl_pain"..math.random(5,7)..".wav")
		umsg.Start("PoisonEffect", ent)
			umsg.Bool(true)
		umsg.End()
	else
		ent:TakeDamage(damage, owner)
	end
end

function GM:PlayerStepSoundTime(pl, iType, bWalking)
	return 350
end

require("guardian")
function ShouldEntitiesCollide(ent1, ent2)
	local enta = Entity(ent1)
	local entb = Entity(ent2)

	if enta:IsPlayer() and entb:IsPlayer() then
		return enta:Team() == entb:Team()
	end

	return false
end
